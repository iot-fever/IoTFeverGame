//
//  Move.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class SingleMove : Move {

    var position : ArmPosition
    var offSet   : NSDate
    
    var success  : Bool
    
    init(position : ArmPosition, offSet : NSDate) {
        self.position = position
        self.offSet = offSet
        self.success = false
    }
    
    func makeMove(data : [Double]) { 
        for sensorValue in data {
            if (position == ArmPosition.Top && sensorValue >= 0) {
                self.success = true
            } else if (position == ArmPosition.Bottom && sensorValue <= 0) {
                self.success = true
            }
        }
    }
    
    func isSuccessful() -> Bool {
        return success
    }
    
    func getImage() -> String {
        return position.rawValue
    }
    
}