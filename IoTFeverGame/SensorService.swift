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
    
    var kuraService     : KuraService
    
    private init() {
       self.kuraService = KuraService.current
    }
    
    func subscribe(listener: SensorDataListenerProtocol) {
        kuraService.subscribe(listener)
    }
    
    func connect(callback : () -> ()) {
        KuraService.current.connect()
        self.kuraService.addConnectedCallback(callback)
    }
    
    func isConnected() -> Bool {
        return self.kuraService.sensorsFound()
    }
    
    func disconnect() -> Bool {
        self.kuraService.unsubscribe()
        return true
    }
    
    func sensorRightStatus() -> Bool {
        return self.kuraService.sensorRightStatus()
    }
    
    func sensorLeftStatus() -> Bool {
        return self.kuraService.sensorLeftStatus()
    }
    
    
}