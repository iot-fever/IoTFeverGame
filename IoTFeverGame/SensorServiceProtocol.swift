//
//  SensorService.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 15/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

protocol SensorServiceProtocol {
    
    func subscribe(_: SensorDataListenerProtocol)
    
    func isConnected()                  -> Bool
    
    func connect(callback : () -> ())
        
    func disconnect()                   -> Bool
    
    func sensorRightStatus()            -> Bool
    
    func sensorLeftStatus()             -> Bool
}
