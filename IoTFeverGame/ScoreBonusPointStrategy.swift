//
//  ScoreBonusPointStrategy.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 13/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

// Gives a player bonus points if (s)he has had only hits in the last 10 moves
class ScoreBonusPointStrategy : ScoreStrategy {
    
    func addHit(player : Player) {
        player.increaseHits()
        
        // if the player has more then 40 moves,
        // his last 10 moves are hits, 
        // and he didn't get a Bonus yet,
        // then add him a 10 Point Bonus
        if (player.hitsHistory.count >= 40 && hasOnlyHitsInHistory(player.hitsHistory) && player.bonus == 0) {
            player.addBonusPoints(10)
        }
    }
    
    private func hasOnlyHitsInHistory(history : [Bool]) -> Bool {
        // if the last 10 moves were hits, then return true 
        // if the last 10 moves weren't hits, then retrun false 
        for var index = ((history.count)-1); index >= ((history.count)-10); --index {
            if !history[index] {
                return false
            }
        }
      
        return true
    }
}
