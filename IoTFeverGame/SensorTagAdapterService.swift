//
//  SensorTagAdapterService.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 15/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation
import CoreBluetooth

class SensorTagAdapterService : SensorService {
    
    static let current  : SensorService = SensorTagAdapterService()
    
    var sensorDelegate  : SensorDelegate
    
    private init() {
        sensorDelegate = SensorDelegate()
    }
    
    func subscribe(listener: SensorDataListener) {
        sensorDelegate.subscribe(listener)
    }
    
    func connect(callback : () -> ()) {
        KuraService.current.getSensors()
        self.sensorDelegate.addConnectedCallback(callback)
    }
    
    func isConnected() -> Bool {
        return self.sensorDelegate.sensorsFound()
    }
    
    func disconnect() -> Bool {
        sensorDelegate.unsubscribe()
        return true
    }
    
    func sensorRightStatus() -> Bool {
        return self.sensorDelegate.sensorRightStatus()
    }
    
    func sensorLeftStatus() -> Bool {
        return self.sensorDelegate.sensorLeftStatus()
    }
    
    
}