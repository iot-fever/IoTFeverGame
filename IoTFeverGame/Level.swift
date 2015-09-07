//
//  Level.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class Level {

    var name: Int
    var duration: Int
    var targetScore: Int
    var minDelay: Int
    var maxDelay: Int
    var moves: [Move]

    init (name: Int, duration: Int, targetScore: Int, minDelay: Int, maxDelay: Int) {
        self.name = 1
        self.duration = duration
        self.targetScore = targetScore
        self.minDelay = minDelay
        self.maxDelay = maxDelay
        
        self.moves = [Move]()
        
        moves.append(Move(name: "TL", path: "TL.jpg"))
        moves.append(Move(name: "TR", path: "TR.jpg"))
        moves.append(Move(name: "BL", path: "BL.jpg"))
        moves.append(Move(name: "BR", path: "BR.jpg"))
        moves.append(Move(name: "TL_TR", path: "TL_TR.jpg"))
        moves.append(Move(name: "TL_BR", path: "TL_BR.jpg"))
        moves.append(Move(name: "TR_BL", path: "TR_BL.jpg"))
        moves.append(Move(name: "BL_BR", path: "BL_BR.jpg"))
    }
}