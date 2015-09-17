//
//  TwoStepMove.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 13/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class DanceMoveImpl : DanceMove {
    
    var bodyParts : [MovingBodyPart]
    
    init(bodyParts : MovingBodyPart...) {
        self.bodyParts = bodyParts
    }
    
    func getInvolvedBodyParts() -> [MovingBodyPart] {
        return bodyParts
    }
    
    func isCompleted() -> Bool {
        for bodyPart in bodyParts {
            if !bodyPart.isCompleted() {
                return false
            }
        }
        return true
    }
    
    func reset() {
        for bodyPart in bodyParts {
            bodyPart.reset()
        }
    }
    
    func getImage() -> String {
        var image : String = ""
        
        for var i = 0;i < bodyParts.count;i++ {
            image += bodyParts[i].getImage()
            if i < bodyParts.count-1 {
                image += "_"
            }
        }

        return image
    }
}
