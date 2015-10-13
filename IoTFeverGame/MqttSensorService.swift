//
//  SensorTagAdapterService.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 15/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation
import CoreBluetooth

class MqttSensorService : SensorServiceProtocol {
    
    static let current  : SensorServiceProtocol = MqttSensorService()
    
    private init() {
    
    }
    
    func subscribe(listener: SensorDataListenerProtocol) {
        MQTT.current.subscribe(listener)
    }
    
    func connect(callback : () -> ()) {
        MQTT.current.connect()
        MQTT.current.addConnectedCallback(callback)
    }
    
    func isConnected() -> Bool {
        return MQTT.current.sensorsFound()
    }
    
    func disconnect() -> Bool {
        MQTT.current.unsubscribe()
        return true
    }
    
    func sensorRightStatus() -> Bool {
        return MQTT.current.sensorRightStatus()
    }
    
    func sensorLeftStatus() -> Bool {
        return MQTT.current.sensorLeftStatus()
    }
}