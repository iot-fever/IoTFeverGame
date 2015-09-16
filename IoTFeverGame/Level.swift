//
//  Level.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class Level {

    var name                : Int
    var duration            : Int
    var delayBetweenMoves   : Float
    var possibleArmPositions : [ArmPosition]
    
    var currentMove : Move?

    init (name: Int, duration: Int, delayBetweenMoves: Float, possibleArmPositions : ArmPosition...) {
        self.name                   = name
        self.duration               = duration
        self.delayBetweenMoves      = delayBetweenMoves
        self.possibleArmPositions   = possibleArmPositions
    }
    
    func newMove(){
        var randomMoveIndexRightArm = Int(arc4random_uniform(UInt32(possibleArmPositions.count)))
         var randomMoveIndexLeftArm = Int(arc4random_uniform(UInt32(possibleArmPositions.count)))
        self.currentMove = TwoStepMove(rightArm: SingleMove(position: possibleArmPositions[randomMoveIndexRightArm],created: NSDate()),
            leftArm: SingleMove(position: possibleArmPositions[randomMoveIndexLeftArm],created: NSDate()),created : NSDate())
    }

}