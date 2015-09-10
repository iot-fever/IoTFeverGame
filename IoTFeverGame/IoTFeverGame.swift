//
//  IoTFeverGame.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class IoTFeverGame : NSObject {
    
    var subscribers     : GameSubscribe
    
    var levels          : [Level]
    
    var runningLevel    : Level
    var startTime       : NSDate
    var gameDuration    : Int
    
    var score           : Int
    var tries           : Int
    
    var player          : Player
        
    static func start (username: String, vc: GameSubscribe) -> IoTFeverGame {
        
        var game = IoTFeverGame(username: username, vc: vc)
        game.doStart()
        return game
    }
    
    private init (username: String, vc: GameSubscribe) {
        self.subscribers    = vc
        self.levels         = [Level]()
        self.levels.append(Level(name: 1, duration: 30, delayBetweenMoves: 3))
        self.levels.append(Level(name: 2, duration: 30, delayBetweenMoves: 2))
        self.levels.append(Level(name: 3, duration: 30, delayBetweenMoves: 1))
        
        self.runningLevel   = levels[0]

        self.startTime      = NSDate()
        
        self.score          = 0
        self.tries          = 3
        self.gameDuration   = 90
        
        self.player         = Player(username: username)
        
        super.init()
    }
    
    // Protocol - Game Subscribe - Implementation

    private func doStart() {
        var timerCountdown  = NSTimer.scheduledTimerWithTimeInterval(1.00, target: self, selector: Selector("updateCountdown"), userInfo: nil, repeats: true)
        var timerImage      = NSTimer.scheduledTimerWithTimeInterval(2.00, target: self, selector: Selector("updateMove"), userInfo: nil, repeats: true)
    }
    
    func updateCountdown() {
        subscribers.leftOverTime(gameDuration)
        gameDuration--
    }
    
    func updateMove() {
        subscribers.moveChanged(self.runningLevel.getNextRandomMove())
    }
    
    
    // Hit - Validation
    func nextLevel() {
    }
    
    func isCompleted() -> Bool {
        
        return true
    }    
    
    func isWon(score: Int) -> Bool {
        
        return true
    }
}