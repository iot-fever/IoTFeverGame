//
//  SensorTagAdapterService.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 15/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation
import CoreBluetooth

class SensorService : SensorServiceProtocol {
    
    static let current  : SensorServiceProtocol = SensorService()
    
    private init() {
    
    }
    
    func subscribe(listener: SensorDataListenerProtocol) {
        MqttService.current.subscribe(listener)
    }
    
    func connect(callback : () -> ()) {
        MqttService.current.detect()
        MqttService.current.addConnectedCallback(callback)
    }
    
    func isConnected() -> Bool {
        return MqttService.current.sensorsFound()
    }
    
    func disconnect() -> Bool {
        MqttService.current.unsubscribe()
        return true
    }
    
    func sensorRightStatus() -> Bool {
        return MqttService.current.sensorRightStatus()
    }
    
    func sensorLeftStatus() -> Bool {
        return MqttService.current.sensorLeftStatus()
    }
}