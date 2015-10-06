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
        KuraService.current.subscribe(listener)
    }
    
    func connect(callback : () -> ()) {
        while !isConnected() {
            KuraService.current.detect()
        }
        KuraService.current.addConnectedCallback(callback)
    }
    
    func isConnected() -> Bool {
        return KuraService.current.sensorsFound()
    }
    
    func disconnect() -> Bool {
        KuraService.current.unsubscribe()
        return true
    }
    
    func sensorRightStatus() -> Bool {
        return KuraService.current.sensorRightStatus()
    }
    
    func sensorLeftStatus() -> Bool {
        return KuraService.current.sensorLeftStatus()
    }
}