//
//  KuraAdapterService.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 2/10/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class NooPSensorDataListener : SensorDataListenerProtocol {

    func onDataRightIncoming(data: [Double]) {
        // swallowing the incoming data
    }

    func onDataLeftIncoming(data: [Double]) {
        // swallowing the incoming data
    }
}

class KuraService  {

    static var current      :KuraService = KuraService()
    
    let bulbTopic           :String
    let kMQTTServerHost     :String
    
    var sensorLeftFound     = false
    var sensorRightFound    = false
    
    var listener            : SensorDataListenerProtocol = NooPSensorDataListener()
    
    var whenSensorsConnected:(()->Void)?
    
    private init() {
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
        self.listener = NooPSensorDataListener()
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
    
    func connect()              {
        println("// STATUS - try to connect")

        var clientID                    = UIDevice.currentDevice().identifierForVendor.UUIDString
        var mqttInstance :MQTTClient    = MQTTClient(clientId: clientID)
        
        mqttInstance.connectToHost(kMQTTServerHost, completionHandler: { (code: MQTTConnectionReturnCode) -> Void in
            if code.value == ConnectionAccepted.value {
                println("// STATUS - CONNECTED")
                
                if  mqttInstance.connected {
                    
                    mqttInstance.subscribe(self.bulbTopic, withCompletionHandler: { grantedQos in
                        println("subscribed to topic \(self.bulbTopic)");
                        
                    // if leftSensor ==
                        self.sensorLeftFound = true
                        self.listener.onDataRightIncoming(self.generateData())
                        
                    // if rightSensor ==
                        self.sensorRightFound = true
                        self.listener.onDataRightIncoming(self.generateData())
                        
                        if (self.sensorsFound()) {
                            self.whenSensorsConnected!()
                        }
                    })
                }
                
            } else {
                println("// STATUS - NOT CONNECTED")
                println(code.value)
            }
        })
    }
    
//    private func publishRight(data: [Double]) {
//        //listener.onDataRightIncoming(data)
//        listener.onDataRightIncoming(generateData())
//    }
    
    private func publishRight() {
        listener.onDataRightIncoming(generateData())
    }
    
//    private func publishLeft(data: [Double]) {
//        //listener.onDataLeftIncoming(data)
//        listener.onDataLeftIncoming(generateData())
//    }
    
    private func publishLeft() {
        listener.onDataLeftIncoming(generateData())
    }
    
    private func generateData() -> [Double] {
        var data = [Double](count: 2,repeatedValue: 0.0)
        data[0] = Double(randomNumber(-100,upper: 100))
        data[1] = Double(randomNumber(-100,upper: 100))
        println("DUMMY")
        println(data)
        return data
    }
    
    func randomNumber (lower : Int , upper : Int) -> Int {
        let result = Int(arc4random_uniform(UInt32(upper - lower + 1))) +   lower
        return result
    }
}