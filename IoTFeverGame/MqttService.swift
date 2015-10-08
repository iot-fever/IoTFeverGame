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
    
    let bulbTopic           :String
    let kMQTTServerHost     :String
    
    var sensorLeftFound     = false
    var sensorRightFound    = false
    
    var listener            : SensorDataListenerProtocol = SensorDataListener()
    
    var leftArmTimer        : NSTimer?
    var rightArmTimer       : NSTimer?
    
    var whenSensorsConnected:(()->Void)?
    
    private override init() {
        self.bulbTopic       = "ysd/20ba/ti_sensortag_v2/c4:be:84:71:97:81/accelerometer"
        self.kMQTTServerHost = "192.168.1.38"
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
        
        /*
        print("// STATUS - DETECT")
        
        var clientID                    = UIDevice.currentDevice().identifierForVendor.UUIDString
        var mqttInstance :MQTTClient    = MQTTClient(clientId: clientID)
        
        mqttInstance.connectToHost(kMQTTServerHost, completionHandler: { (code: MQTTConnectionReturnCode) -> Void in
            if code.value == ConnectionAccepted.value {
                print("// STATUS - CONNECTED")
        
                if  mqttInstance.connected {
                    
                    mqttInstance.subscribe(self.bulbTopic, withCompletionHandler: { grantedQos in
                        prprintsubscribed to topic \(self.bulbTopic)");
                        
                        // if leftSensor ==
                        self.sensorLeftFound = true
                        
                        // if rightSensor ==
                        self.sensorRightFound = true
                        
//                        if (self.sensorsFound()) {
//                            self.connected()
//                            self.whenSensorsConnected!()
//                        }
                        
                        mqttInstance.messageHandler = { (message : MQTTMessage!) -> Void in
                            print("Message /(message.payloadString())")
                            print(message.payloadString())
                            
                        
                            //var person = Person.parseFromData(bytes) // from NSDatas
                            
                            //person.data() //return NSData
                           
                        }
                    })
                }
            } else {
                println("// STATUS - NOT CONNECTED")
                println(code.value)
            }
        })
        */
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