//
//  LevelService.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class LevelService {
    
 
    static func isWon(score: Int) -> Bool {
        
        return true
    }
    
    static func nextLevel() -> Level {

        if EntityManager.entityManager.get().runningLevel.name <= 3 {
            for level in EntityManager.entityManager.get().levels {
                if level.name == EntityManager.entityManager.get().runningLevel.name++ {
                    return level
                }
            }
        }
        
        return EntityManager.entityManager.get().runningLevel
    }
}