//
//  SingleArmDanceMove.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 16/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class SingleArmDanceMove : DanceMove {
    
    var arm : MovingArmBodyPart
    
    init(arm : MovingArmBodyPart) {
        self.arm = arm
    }
    
    func getInvolvedBodyParts() -> [MovingBodyPart] {
        var involvedParts = [MovingBodyPart]()
        involvedParts.append(arm)
        return involvedParts
    }
    
    func isCompleted() -> Bool {
        return arm.isCompleted()
    }
    
    func getImage() -> String {
        return arm.getImage()
    }
    
    func reset() {
        self.arm.reset()
    }
}

