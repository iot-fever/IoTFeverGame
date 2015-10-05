//
//  SensorDataListener.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 15/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

protocol SensorDataListenerProtocol {
    
    func onDataRightIncoming(data: [Double])
    
    func onDataLeftIncoming(data: [Double])
}

