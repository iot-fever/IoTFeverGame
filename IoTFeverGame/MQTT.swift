//
//  KuraAdapterService.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 2/10/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class MQTT : NSObject {

    static var current      :MQTT = MQTT()
    
    let bulbTopicLeft       :String
    let bulbTopicRight      :String
    let kMQTTServerHost     :String
    
    var sensorLeftFound     = false
    var sensorRightFound    = false
    
    var listener            : SensorDataListenerProtocol = SensorDataListener()
    
    var leftArmTimer        : NSTimer?
    var rightArmTimer       : NSTimer?
    
    var whenSensorsConnected:(()->Void)?
    
    private override init() {
        self.bulbTopicLeft          = "ysd/20ba/ti_sensortag_v2/c4:be:84:71:97:81/accelerometer"
        self.bulbTopicRight         = "ysd/a03f/ti_sensortag_v2/b0:b4:48:b9:88:80/accelerometer"
        self.kMQTTServerHost        = "192.168.1.38"
    }
    
    func addConnectedCallback(callback : () -> ()) {
        self.whenSensorsConnected = callback
    }
    
    func subscribe(listener: SensorDataListenerProtocol) {
        self.listener = listener
    }
    
    func unsubscribe() {
        self.listener = SensorDataListener()
    }
    
    func sensorsFound()         -> Bool {
        return sensorLeftFound && sensorRightFound
    }
    
    func sensorRightStatus()    -> Bool {
        return sensorRightFound
    }
    
    func sensorLeftStatus()     -> Bool {
        return sensorLeftFound
    }
    
    func connect() {
        
        print("// STATUS - DETECT")
        
        let clientID                    = UIDevice.currentDevice().identifierForVendor!.UUIDString
        // var mqttInstance :MQTTClient    = MQTTClient(clientId: clientID)

        let mqttInstanceLEFT    :MQTTClient    = MQTTClient(clientId: clientID)
        let mqttInstanceRIGHT   :MQTTClient    = MQTTClient(clientId: clientID)
        
        mqttInstanceLEFT.connectToHost(kMQTTServerHost, completionHandler: { (code: MQTTConnectionReturnCode) -> Void in
            // if code.value == ConnectionAccepted.value {
            print("// STATUS LEFT - CONNECTED")
            
            if mqttInstanceLEFT.connected {
                
                mqttInstanceLEFT.subscribe(self.bulbTopicLeft, withCompletionHandler: { grantedQos in
                    print("topic - LEFT \(self.bulbTopicLeft)");
                    
                    self.sensorLeftFound = true
                    
                    mqttInstanceLEFT.messageHandler = { (message : MQTTMessage!) -> Void in
                        
                        do {
                            var payload = try Kuradatatypes.KuraPayload.parseFromData(message.payload)
                            print("payload result LEFT \(payload.metric[2].floatValue)")
                            self.listener.onDataLeftIncoming(payload.metric[2].floatValue)
                        } catch let error as ErrorType {
                            print("Error reveicing data LEFT ")
                        }
                    }
                })
            }
        })
        
        mqttInstanceRIGHT.connectToHost(kMQTTServerHost, completionHandler: { (code: MQTTConnectionReturnCode) -> Void in
            // if code.value == ConnectionAccepted.value {
            print("// STATUS RIGHT - CONNECTED")
            
            if  mqttInstanceRIGHT.connected {
                
                mqttInstanceRIGHT.subscribe(self.bulbTopicRight, withCompletionHandler: { grantedQos in
                    print("topic - RIGHT \(self.bulbTopicRight)");
                    
                    self.sensorRightFound = true
                    
                    mqttInstanceRIGHT.messageHandler = { (message : MQTTMessage!) -> Void in
                        
                        do {
                            var payload = try Kuradatatypes.KuraPayload.parseFromData(message.payload)
                            print("payload result RIGHT \(payload.metric[2].floatValue)")
                            self.listener.onDataRightIncoming(payload.metric[2].floatValue)
                        } catch let error as ErrorType {
                            print("Error reveicing data RIGHT \(error)")
                        }
                    }
                })
            }
        })
    }
    
    func isConnected() -> Bool {
        return self.sensorsFound()
    }
    
    func disconnect() {
        rightArmTimer!.invalidate()
        leftArmTimer!.invalidate()
    }
}