//
//  LevelService.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class LevelService {
    
    static func getNextRandomMove() -> Move {
        
        return EntityManager.get().runningLevel.moves[Int(arc4random_uniform(7) + 0)]
    }
    
    static func isWon(score: Int) -> Bool {
        
        return true
    }
    
    static func nextLevel() -> Level {

        if EntityManager.get().runningLevel.name <= 3 {
            for level in EntityManager.get().levels {
                if level.name == EntityManager.get().runningLevel.name++ {
                    return level
                }
            }
        }
        
        return EntityManager.get().runningLevel
    }
}