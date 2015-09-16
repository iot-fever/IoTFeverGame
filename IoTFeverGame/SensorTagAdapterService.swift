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
    
    var listener : SensorDataListener?
    
    var sensorTagService : SensorDelegate
    
    init() {
        self.sensorTagService = sensorDelegate
    }
    
    func subscribe(listener: SensorDataListener) {
        self.listener = listener
    }
    
    func connect() -> Bool {
        centralManager = CBCentralManager(delegate: sensorTagService, queue: nil)
        sensorTagService.subscribe(listener!)
        return sensorTagService.sensorsFound()
    }
    
    func disconnect() -> Bool {
        centralManager.stopScan()
        sensorTagService.unsubscribe()
        return true
    }
}