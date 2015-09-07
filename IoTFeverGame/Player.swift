//
//  Player.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class Player {

    var calibrateValue: Int
    var name: String
    
    init (calibrateValue: Int, name: String) {
        self.calibrateValue = calibrateValue
        self.name = name
    }    
}