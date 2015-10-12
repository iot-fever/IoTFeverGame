//
//  Move.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class MovingArmBodyPart : MovingBodyPartProtocol {
    
    var position : ArmPosition
    
    var completed  : Bool
    
    var image : String
    
    var rightSide : Bool
    
    init(position : ArmPosition, image : String, rightSide : Bool) {
        self.position = position
        self.completed = false
        self.image = image
        self.rightSide = rightSide
    }
    
    func mimic(data : Float) {
        // TODO - check data unit
        if (position == ArmPosition.Top && data >= 0.1) {
            print(position)
            self.completed = true
            return
        } else if (position == ArmPosition.Bottom && data <= -0.01) {
            self.completed = true
            return
        }
    }
   
    func getImage() -> String {
        return self.image
    }

    func isCompleted() -> Bool {
        return self.completed
    }
    
    func reset() {
        
        self.completed = false
    }
    
}