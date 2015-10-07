//
//  SHPushEngine.m
//  SmartHome
//
//  Created by Tao Yuan on 13/12/14.
//  Copyright (c) 2014 Tao Yuan. All rights reserved.
//

#import "SHPushEngine.h"
#import "SHUserPreference.h"
#import "SHCredentialManager.h"
#import "SHRootDevice.h"
#import "SHRetrieveAuthTokenService.h"
#import <UIKit/UIKit.h>

NSString* const kSHPushEngineMessageUpdate = @"mqttEngineMessageUpdate";
NSString* const kSHPushEngineStatusUpdate = @"mqttEngineConnectionStatusUpdate";

NSString* const kHiveMQClientCertificateFileName = @"mqtt_q_smarthome_bosch-si_com_Symantec_Class_Secure_Server_CA_-_G";
NSString* const kHiveMQClientPublicKeyFileName = @"pk_mqtt_q_smarthome_bosch-si_com_Symantec_Class_Secure_Server_CA_-_G";

static const unsigned short kInsecuredPort = 1883;
static const unsigned short kSecuredPort = 8883;

@interface SHPushEngine ()

@property (nonatomic, strong) MQTTClient* client;
@property (nonatomic, readwrite) BOOL appSleeping;

@end

@implementation SHPushEngine

- (instancetype)init
{
    self = [super init];
    if (self){
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    self.client = nil;
}

- (BOOL)isConnected
{
    return self.client.connected;
}

- (MQTTClient*)client
{
    if (!_client){
        _client = [[MQTTClient alloc] initWithClientId:[self clientID] cleanSession:YES];
    }
    return _client;
}

- (void)start
{
    SHPushEngine* __weak weakself = self;
    [self.client connectWithCompletionHandler:^(MQTTConnectionReturnCode code)
    {
        NSLog(@"Push engine connected: %lu", (unsigned long)code);
        if (code == ConnectionRefusedNotAuthorized) {
            //fire event to retrieve new token
            SimpleCallback callback= ^(){
                [weakself start];
            };
            [[NSNotificationCenter defaultCenter] postNotificationName:kSHRetrieveNewToken
                                                                object:callback
                                                              userInfo:nil];
        }
        else {
            NSDictionary* userInfo = @{ @"code" : [NSNumber numberWithUnsignedInteger:code] };
            [weakself performSelectorOnMainThread:@selector(postConnectionStatusUpdateNotification:)
                                       withObject:userInfo
                                    waitUntilDone:NO];
            [self setupTopics];
        }
    }];
}

- (void)stop
{
    [self.client disconnectWithCompletionHandler:^(NSUInteger code) {
        NSLog(@"Push engine is stopped with code %u", (unsigned int)code);
    }];
}

- (void)setup
{
    [self setupHost];
    [self setupPort];
    [self setupCredentials];
    [self setupMessageHandler];
    [self setupConnectionFailureHandler];
    [self setupTLSCertificate];
    [self setupListeners];
}

- (void)setupListeners
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAppEnteredBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAppEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)onAppEnteredBackground:(NSNotification*)notification
{
    self.appSleeping = YES;
}

- (void)onAppEnteredForeground:(NSNotification*)notification
{
    self.appSleeping = NO;
}

- (void)setupTLSCertificate
{
    if (self.client.port == kSecuredPort) {
        NSString* caFile = [[NSBundle mainBundle] pathForResource:kHiveMQClientCertificateFileName ofType:@"cer"];
        self.client.cafile = caFile;
        
        NSString* pkFile = [[NSBundle mainBundle] pathForResource:kHiveMQClientPublicKeyFileName ofType:@"der"];
        self.client.pkfile = pkFile;
    }
    else {
        self.client.cafile = nil;
    }
}

//ref: http://nshipster.com/uuid-udid-unique-identifier/
- (NSString*)clientID
{
    NSString* vendorIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString* productName = [self appDisplayName];
    NSString* rootDeviceID = [[SHRootDevice rootDevice] rootDeviceID];
    
    NSString* mqttIdentifier = [NSString stringWithFormat:@"%@_%@_%@", vendorIdentifier, productName, rootDeviceID];
    
    return mqttIdentifier;
}

- (NSString*)appDisplayName
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    NSString *prodName = [info objectForKey:(NSString*)kCFBundleNameKey];
    return prodName;
}

- (void)setupHost
{
    [self.client setHost:[SHUserPreference sharedPreference].mqttHost];
}

- (void)setupPort
{
    if ([SHUserPreference sharedPreference].mqttPort) {
        self.client.port = [[SHUserPreference sharedPreference].mqttPort unsignedIntValue];
    }
    else {
        self.client.port = kInsecuredPort;
    }
}

- (void)setupCredentials
{
    [self.client setUsername:[SHCredentialManager sharedManager].pushAuthID];
    [self.client setPassword:[SHCredentialManager sharedManager].pushAuthToken];
}

- (void)setupTopics
{
    [self.client subscribe:[NSString stringWithFormat:@"/%@/+/#", [SHRootDevice rootDevice].rootDeviceID] withCompletionHandler:nil];
}

- (void)setupMessageHandler
{
    SHPushEngine* __weak weakSelf = self;
    [self.client setMessageHandler:^(MQTTMessage* message){
        NSError* error;
        id json = [NSJSONSerialization JSONObjectWithData:message.payload
                                                  options:0
                                                    error:&error];
        if (error){
            NSLog(@"Unknown json format getting pushed from hive MQ: \n%@", json);
            return;
        }
        
        NSLog(@"push: %@", json);
        NSDictionary* userInfo = @{ @"data" : json, @"topic": message.topic };
        [weakSelf performSelectorOnMainThread:@selector(postMessageUpdateNotification:) withObject:userInfo waitUntilDone:NO];
    }];
}

- (void)setupConnectionFailureHandler
{
    SHPushEngine* __weak weakself = self;
    [self.client setDisconnectionHandler:^(MQTTConnectionReturnCode code) {
        NSLog(@"push disconnected: %lu", (unsigned long)code);
        
        if (code == ConnectionRefusedNotAuthorized){
            [weakself stop];
            SHEntityService* service = [[SHRetrieveAuthTokenService alloc] init];
            [service runSuccess:^(HTTP_STATUS_CODE status, id data) {
                [weakself setup];
                [weakself start];
            } failure:nil];
            return;
        }
        
        if (!weakself.appSleeping) {
            NSDictionary* userInfo = @{ @"code" : [NSNumber numberWithUnsignedInteger:code] };
            [weakself performSelectorOnMainThread:@selector(postConnectionStatusUpdateNotification:)
                                       withObject:userInfo
                                    waitUntilDone:NO];
            NSLog(@"Push engine disconnected: %lu", (unsigned long)code);
        }
    }];
}

- (void)postMessageUpdateNotification:(id)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSHPushEngineMessageUpdate
                                                        object:nil
                                                      userInfo:userInfo];
}

- (void)postConnectionStatusUpdateNotification:(id)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSHPushEngineStatusUpdate
                                                        object:self
                                                      userInfo:userInfo];
}

@end

