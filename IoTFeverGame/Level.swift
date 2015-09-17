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
    var possibleDanceMoves  : [Int: DanceMove]
    
    var currentMove : DanceMove = DanceMoveImpl(bodyParts : MovingArmBodyPart(position: ArmPosition.Top, image: "TR",rightSide : true))

    init (name: Int, duration: Int, delayBetweenMoves: Float, possibleDanceMoves : [Int:DanceMove]) {
        self.name                   = name
        self.duration               = duration
        self.delayBetweenMoves      = delayBetweenMoves
        self.possibleDanceMoves     = possibleDanceMoves
    }
    
    func newMove(){
        var randomDanceMove = Int(arc4random_uniform(UInt32(possibleDanceMoves.count)))
        
        var createdMove = possibleDanceMoves[randomDanceMove]
        
//        if (matchesLastMove(createdMove!)) {
//            newMove() // we don't want moves of same kind in a row
//        }
        
        self.currentMove = createdMove!
    }
    
    func matchesLastMove(createdMove : DanceMove) -> Bool {
        var same =  createdMove === self.currentMove
        println("\(createdMove) vs. \(self.currentMove) matches = \(same)")
        
        return same
    }

}