//
//  KuraAdapterService.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 2/10/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

// The UUID of the 2 sensors
let sensorLeftUUID = NSUserDefaults.standardUserDefaults().stringForKey("left_sensor_uuid")
let sensorRightUUID = NSUserDefaults.standardUserDefaults().stringForKey("right_sensor_uuid")

protocol KuraServiceDelegate {
    func getSensor(game: DiceGame)
    func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(game: DiceGame)
}

protocol SensorDataListener {
    
    func onDataRightIncoming(data: [Double])
    
    func onDataLeftIncoming(data: [Double])
}

class KuraService : SensorService {

    static var current      :KuraService = KuraService()
    
    let bulbTopic           :String
    let kMQTTServerHost     :String
    
    var sensorLeftFound     = false
    var sensorRightFound    = false
    
    var listener            : SensorDataListener = NooPSensorDataListener()
    
    var whenSensorsConnected:(()->Void)?
    
    private init() {
        self.bulbTopic       = "$EDC/iot-fever/20BA/iotfever/lights/1/state"
        self.kMQTTServerHost = "192.168.1.38"
    }
    
    func addConnectedCallback(callback : () -> ()) {
        self.whenSensorsConnected = callback
    }
    
    func subscribe(listener: SensorDataListener) {
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
    
    func connect()              -> Bool {
        println("// STATUS - try to connect")

        var clientID                    = UIDevice.currentDevice().identifierForVendor.UUIDString
        var mqttInstance :MQTTClient    = MQTTClient(clientId: clientID)
        
        mqttInstance.connectToHost(kMQTTServerHost, completionHandler: { (code: MQTTConnectionReturnCode) -> Void in
            if code.value == ConnectionAccepted.value {
                println("// STATUS - CONNECTED")
                
                if  mqttInstance.connected {
                    mqttInstance.publishString("{\"on\":true,\"hue\":\(25500)}", toTopic: self.bulbTopic, withQos: ExactlyOnce, retain: false, completionHandler: { mid in
                        mqttInstance.disconnectWithCompletionHandler({ mid in
                            println("// STATUS - DATA RECEIVED")
                            
                            // if leftSensor == 
                                self.sensorLeftFound = true
                            // if rightSensor ==
                                self.sensorRightFound = true
                            
                            if (self.sensorsFound()) {
                                self.whenSensorsConnected!()
                            }
                        })
                    })
                }
                
            } else {
                println("// STATUS - NOT CONNECTED")
                println(code.value)
            }
        })
    }
    
    func peripheral() {
    
        // if leftSensor ==
        // accelData -> Streams Sensor Data Left
        // self.publishLeft(accelData)
        
        // if rightSensor ==
        // accelData -> Streams Sensor Data Right
        // self.publishRight(accelData)

    }
    
    private func publishRight(data: [Double]) {
        listener.onDataRightIncoming(data)
    }
    
    private func publishLeft(data: [Double]) {
        listener.onDataLeftIncoming(data)
    }
}