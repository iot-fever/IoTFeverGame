//
//  IoTFeverGame.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class LevelBuilder {
    
    static let TOP_RIGHT    : MovingBodyPart = MovingArmBodyPart(position: ArmPosition.Top, image: "TR", rightSide : true)
    static let TOP_LEFT     : MovingBodyPart = MovingArmBodyPart(position: ArmPosition.Top, image: "TL", rightSide : false)
    static let BOTTOM_RIGHT : MovingBodyPart = MovingArmBodyPart(position: ArmPosition.Bottom, image: "BR", rightSide : true)
    static let BOTTOM_LEFT  : MovingBodyPart = MovingArmBodyPart(position: ArmPosition.Bottom, image: "BL", rightSide : false)
    
    static func createLevelOne() -> Level {
        var danceMoves = [Int: DanceMove]()
        danceMoves[0] = DanceMoveImpl(bodyParts: TOP_RIGHT)
        danceMoves[1] = DanceMoveImpl(bodyParts: BOTTOM_RIGHT)
        danceMoves[2] = DanceMoveImpl(bodyParts: TOP_LEFT)
        danceMoves[3] = DanceMoveImpl(bodyParts: BOTTOM_LEFT)
        
        return Level(name: 1, duration: 10, delayBetweenMoves: 2.0, possibleDanceMoves : danceMoves)
    }
    
    static func createLevelTwo() -> Level {
        var danceMoves = [Int: DanceMove]()
        danceMoves[0] = DanceMoveImpl(bodyParts: TOP_LEFT,TOP_RIGHT)
        danceMoves[1] = DanceMoveImpl(bodyParts: BOTTOM_LEFT,BOTTOM_RIGHT)
        danceMoves[2] = DanceMoveImpl(bodyParts: BOTTOM_LEFT,TOP_RIGHT)
        danceMoves[3] = DanceMoveImpl(bodyParts: TOP_LEFT,BOTTOM_RIGHT)
        
        return Level(name: 2, duration: 15, delayBetweenMoves: 1.5, possibleDanceMoves : danceMoves)
    }
    
    static func createLevelThree() -> Level {
        var danceMoves = [Int: DanceMove]()
        danceMoves[0] = DanceMoveImpl(bodyParts: TOP_RIGHT)
        danceMoves[1] = DanceMoveImpl(bodyParts: BOTTOM_RIGHT)
        danceMoves[2] = DanceMoveImpl(bodyParts: TOP_LEFT)
        danceMoves[3] = DanceMoveImpl(bodyParts: BOTTOM_LEFT)
        
        danceMoves[4] = DanceMoveImpl(bodyParts: TOP_LEFT,TOP_RIGHT)
        danceMoves[5] = DanceMoveImpl(bodyParts: BOTTOM_LEFT,BOTTOM_RIGHT)
        danceMoves[6] = DanceMoveImpl(bodyParts: BOTTOM_LEFT,TOP_RIGHT)
        danceMoves[7] = DanceMoveImpl(bodyParts: TOP_LEFT,BOTTOM_RIGHT)
 
        return Level(name: 3, duration: 10, delayBetweenMoves: 1.0, possibleDanceMoves : danceMoves)
    }
}

class IoTFeverGame : NSObject {
    
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
        
        self.levels.append(LevelBuilder.createLevelOne())
        self.levels.append(LevelBuilder.createLevelTwo())
        self.levels.append(LevelBuilder.createLevelThree())
        
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