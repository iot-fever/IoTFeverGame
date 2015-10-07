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
        self.bulbTopic       = "$EDC/iot-fever/20BA/iotfever/lights/1/state"
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
    
    // TODO - implement a stream, that my method gets triggered as soon as something changes 
    
    func detect() {
        
        println("// STATUS - DETECT")
        
        var clientID                    = UIDevice.currentDevice().identifierForVendor.UUIDString
        var mqttInstance :MQTTClient    = MQTTClient(clientId: clientID)
        
        // if leftSensor ==
        self.sensorLeftFound = true
        
        // if rightSensor ==
        self.sensorRightFound = true
        
        if (self.sensorsFound()) {
            self.connected()
            //self.whenSensorsConnected!()
        }

//        mqttInstance.connectToHost(kMQTTServerHost, completionHandler: { (code: MQTTConnectionReturnCode) -> Void in
//            if code.value == ConnectionAccepted.value {
//                println("// STATUS - CONNECTED")
//                
//                if  mqttInstance.connected {
//                    
//                    mqttInstance.subscribe(self.bulbTopic, withCompletionHandler: { grantedQos in
//                        println("subscribed to topic \(self.bulbTopic)");
//                        
//                        // if leftSensor ==
//                        self.sensorLeftFound = true
//                        
//                        // if rightSensor ==
//                        self.sensorRightFound = true
//                        
//                        if (self.sensorsFound()) {
//                            self.connected()
//                            self.whenSensorsConnected!()
//                        }
//                    })
//                }
//                
//            } else {
//                println("// STATUS - NOT CONNECTED")
//                println(code.value)
//            }
//        })
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
        println("DUMMY - Integrated Mode")
        println(data)
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