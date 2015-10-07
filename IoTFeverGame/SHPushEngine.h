//
//  SHPushEngine.h
//  SmartHome
//
//  Created by Tao Yuan on 13/12/14.
//  Copyright (c) 2014 Tao Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTTKit.h"

extern NSString* const kSHPushEngineMessageUpdate;
extern NSString* const kSHPushEngineStatusUpdate;

@interface SHPushEngine : NSObject

@property (nonatomic, readonly) BOOL isConnected;

- (void)start;

- (void)stop;

- (void)setupTopics;

@end
