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
    
    var completed  : Bool
    
    var created : NSDate
    
    init(position : ArmPosition, created : NSDate) {
        self.position = position
        self.completed = false
        self.created = created
    }
    
    func mimicMove(data : [Double]) {
        for sensorValue in data {
            if (position == ArmPosition.Top && sensorValue >= 0) {
                self.completed = true
                return
            } else if (position == ArmPosition.Bottom && sensorValue <= 0) {
                self.completed = true
                return
            }
        }
    }
    
    func getCreated() -> NSDate {
        return created
    }
    

    func isCompleted() -> Bool {
        return self.completed
    }
    
    func getImage() -> String {
        return position.rawValue
    }
    
}