//
//  IoTFeverGame.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class IoTFeverGame : NSObject {
    
    let LEVEL_EASY = Level(name: 1, duration: 5, delayBetweenMoves: 2.0, possibleArmPositions: ArmPosition.Top,ArmPosition.Bottom)
    
    let LEVEL_MEDIUM = Level(name: 2, duration: 5, delayBetweenMoves: 1.0, possibleArmPositions: ArmPosition.Top,ArmPosition.Bottom)
    
    let LEVEL_HARD = Level(name: 3, duration: 5, delayBetweenMoves: 0.5, possibleArmPositions: ArmPosition.Top,ArmPosition.Bottom)
    
    var currentLevelIndex : Int
    var levels          : [Level]
    var startTime       : NSDate?
    var isRunning       : Bool
    var player          : Player
    var scoreStrategy   : ScoreStrategy
    
    // when you start a game
    
    init (username: String) {
        self.isRunning = false
        self.levels = [Level]()
        self.levels.append(LEVEL_EASY)
        self.levels.append(LEVEL_MEDIUM)
        self.levels.append(LEVEL_HARD)
        self.scoreStrategy = ScoreBonusPointStrategy()
        self.player = Player(username: username, lives: 3)
        self.currentLevelIndex = 0
        super.init()
    }
    
    func start() -> Level {
        self.startTime      = NSDate()
        self.isRunning = true
        var level = self.levels[currentLevelIndex]
        return level
    }
    
    func increaseHits() {
        self.scoreStrategy.addHit(player)
    }
    
    func stopGame() {
        isRunning = false
    }
    
    func hasNextLevel() -> Bool {
        return currentLevelIndex < levels.count - 1
    }
    
    func getNextLevel() -> Level {
        ++self.currentLevelIndex
        return levels[self.currentLevelIndex]
    }
    
    func getCurrentLevel() -> Level {
        return levels[currentLevelIndex]
    }
    
    
    
}