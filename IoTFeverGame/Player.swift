//
//  Player.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class Player {

    var name            : String
    var score           : Int
    var lives           : Int
    
    init (username: String, lives : Int) {
        self.name  = username
        self.lives = lives
        self.score = 0
    }
    
    func deductLive() {
        --lives
    }
    
    func isAlive() -> Bool {
        return lives > 0
    }
    
    func increaseHits() {
        ++score
    }
}