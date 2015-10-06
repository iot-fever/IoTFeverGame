//
//  SingleArmDanceMove.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 16/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class SingleArmDanceMove : DanceMoveProtocol {
    
    var arm : MovingArmBodyPart
    
    init(arm : MovingArmBodyPart) {
        self.arm = arm
    }
    
    func getInvolvedBodyParts() -> [MovingBodyPartProtocol] {
        var involvedParts = [MovingBodyPartProtocol]()
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

