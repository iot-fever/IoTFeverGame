//
//  IoTFeverGame.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class IoTFeverGame {

    var runningLevel: Level
    var startTime: NSDate
    var finalScore: Int
       
    var player: Player
    var timer: Timer
    var levels: [Level]
    
    init (player: Player, timer: Timer) {
        
        self.startTime = NSDate()
        self.finalScore = 0
        
        self.player = player
        self.timer = timer
        
        self.levels = [Level]()
        self.levels.append(Level(name: 1, duration: 30, targetScore: 25, minDelay: 2, maxDelay: 4 ))
        self.levels.append(Level(name: 2, duration: 30, targetScore: 25, minDelay: 2, maxDelay: 3 ))
        self.levels.append(Level(name: 3, duration: 30, targetScore: 25, minDelay: 1, maxDelay: 2 ))
        
        self.runningLevel = levels[0]
    }
    
}