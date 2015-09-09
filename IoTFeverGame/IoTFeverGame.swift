//
//  IoTFeverGame.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class IoTFeverGame {

    var levels: [Level]
    
    var runningLevel: Level
    var startTime: NSDate
    
    var score: Int
    var tries: Int
    
    var player: Player
    
    init (player: Player) {
        
        self.levels = [Level]()
        self.levels.append(Level(name: 1, duration: 30))
        self.levels.append(Level(name: 2, duration: 30))
        self.levels.append(Level(name: 3, duration: 30))
        
        self.runningLevel   = levels[0]
        
        self.startTime      = NSDate()
        
        self.score          = 0
        self.tries          = 3
        self.player         = player
    }
    
}