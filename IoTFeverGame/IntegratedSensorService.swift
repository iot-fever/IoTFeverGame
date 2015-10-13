//
//  MoveService.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation
import CoreBluetooth

class IntegratedSensorService : SensorServiceProtocol {
    
    static let current : SensorServiceProtocol = IntegratedSensorService()
    
    var sensorDelegate : SensorDelegate
    
    var centralManager : CBCentralManager?
    
    private init() {
        sensorDelegate = SensorDelegate()
    }
    
    func subscribe(listener: SensorDataListenerProtocol) {
        sensorDelegate.subscribe(listener)
    }
    
    func connect(callback : () -> ()) {
        centralManager = CBCentralManager(delegate: sensorDelegate, queue: dispatch_get_main_queue())
        self.sensorDelegate.addConnectedCallback(callback)
    }
    
    func isConnected() -> Bool {
        return self.sensorDelegate.sensorsFound()
    }
    
    func disconnect() -> Bool {
        centralManager!.stopScan()
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
