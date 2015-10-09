//
//  KuraAdapterService.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 2/10/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class MqttService : NSObject {

    static var current      :MqttService = MqttService()
    
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
        self.bulbTopicRight         = "ysd/20ba/ti_sensortag_v2/b0:b4:48:b9:88:80/accelerometer"
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
    
    func detect() {
        
        print("// STATUS - DETECT")
        
        let clientID                    = UIDevice.currentDevice().identifierForVendor!.UUIDString
        // var mqttInstance :MQTTClient    = MQTTClient(clientId: clientID)

        let mqttInstanceLEFT    :MQTTClient    = MQTTClient(clientId: clientID)
        let mqttInstanceRIGHT   :MQTTClient    = MQTTClient(clientId: clientID)
        
        print("TRY - LEFT")
        mqttInstanceLEFT.connectToHost(kMQTTServerHost, completionHandler: { (code: MQTTConnectionReturnCode) -> Void in
            // if code.value == ConnectionAccepted.value {
            print("// STATUS LEFT - CONNECTED")
            
            if mqttInstanceLEFT.connected {
                
                mqttInstanceLEFT.subscribe(self.bulbTopicRight, withCompletionHandler: { grantedQos in
                    print("subscribed to topic LEFT \(self.bulbTopicRight)");
                    
                    self.sensorLeftFound = true
                    
                    mqttInstanceLEFT.messageHandler = { (message : MQTTMessage!) -> Void in
                        print("Message LEFT")
                        print("payload LEFT - \(message.payload)")
                        
                        do {
                            var payload = try Kuradatatypes.KuraPayload.parseFromData(message.payload)
                            print("payload result \(payload)")
                        } catch _ {
                            print("Error reveicing data LEFT ")
                        }
                    }
                })
            }
        })
        
        print("TRY - RIGHT")
        mqttInstanceRIGHT.connectToHost(kMQTTServerHost, completionHandler: { (code: MQTTConnectionReturnCode) -> Void in
            // if code.value == ConnectionAccepted.value {
            print("// STATUS RIGHT - CONNECTED")
            
            if  mqttInstanceRIGHT.connected {
                
                mqttInstanceRIGHT.subscribe(self.bulbTopicRight, withCompletionHandler: { grantedQos in
                    print("subscribed to topic RIGHT \(self.bulbTopicRight)");
                    
                    self.sensorRightFound = true
                    
                    mqttInstanceRIGHT.messageHandler = { (message : MQTTMessage!) -> Void in
                        print("Message RIGHT")
                        print("payload RIGHT - \(message.payload)")
                        
                        do {
                            var payload = try Kuradatatypes.KuraPayload.parseFromData(message.payload)
                            print("payload result \(payload)")
                        } catch let error as ErrorType {
                            print("Error reveicing data RIGHT \(error)")
                        }
                    }
                })
            }
        })
    }

    func connected() {
        rightArmTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("generateSensorDataFromDeviceRightArm"), userInfo: nil, repeats: true)
        
        leftArmTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("generateSensorDataFromDeviceLeftArm"), userInfo: nil, repeats: true)
    }
    
    func generateSensorDataFromDeviceRightArm() {
        listener.onDataRightIncoming(generateData())
    }
    
    func generateSensorDataFromDeviceLeftArm() {
        listener.onDataLeftIncoming(generateData())
    }
    
    func generateData() -> [Double] {
        var data = [Double](count: 2,repeatedValue: 0.0)
        data[0] = Double(randomNumber(-100,upper: 100))
        data[1] = Double(randomNumber(-100,upper: 100))
        print("DUMMY - Integrated Mode")
        print(data)
        return data
    }
    
     func randomNumber (lower : Int , upper : Int) -> Int {
        let result = Int(arc4random_uniform(UInt32(upper - lower + 1))) +   lower
        return result
    }
    
    func disconnect() {
        rightArmTimer!.invalidate()
        leftArmTimer!.invalidate()
    }
}