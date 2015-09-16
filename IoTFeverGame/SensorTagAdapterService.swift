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
    
    var sensorDelegate : SensorDelegate
    
    var centralManager : CBCentralManager?
    
    init() {
        sensorDelegate = SensorDelegate()
    }
    
    func subscribe(listener: SensorDataListener) {
        sensorDelegate.subscribe(listener)
    }
    
    func connect(callback : () -> ()) {
        centralManager = CBCentralManager(delegate: sensorDelegate, queue: nil)
        self.sensorDelegate.addConnectedCallback(callback)
        
    }
    
    func disconnect() -> Bool {
        centralManager!.stopScan()
        sensorDelegate.unsubscribe()
        return true
    }
}