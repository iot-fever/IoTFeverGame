//
//  TwoStepMove.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 13/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class TwoStepMove : Move {
    
    var rightArm,leftArm : SingleMove
    
    var created : NSDate
    
    init(rightArm : SingleMove, leftArm : SingleMove, created : NSDate) {
        self.rightArm = rightArm
        self.leftArm = leftArm
        self.created = created
    }
    
    func getCreated() -> NSDate {
        return created
    }
    
    func isCompleted() -> Bool {
        return rightArm.isCompleted() && leftArm.isCompleted()
    }
    
    func getImage() -> String {
        if (rightArm.position == ArmPosition.Top && leftArm.position == ArmPosition.Top) {
            println("TL - TR")
            return "TL_TR_1.png"
        } else if (rightArm.position == ArmPosition.Top && leftArm.position == ArmPosition.Bottom) {
            println("BL - TR")
            return "BL_TR_1.png"
        } else if (rightArm.position == ArmPosition.Bottom && leftArm.position == ArmPosition.Top) {
            println("TL - BR")
            return "TL_BR_1.png"
        } else {
            println("BL - BR")
            return "BL_BR_1.png"
        }
    }
}
