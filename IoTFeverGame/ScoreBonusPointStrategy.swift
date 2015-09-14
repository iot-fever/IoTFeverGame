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
        
        if (player.hitsHistory.count == 10 && hasOnlyHitsInHistory(player.hitsHistory)) {
            player.addBonusPoints(10)
        }

    }
    
    private func hasOnlyHitsInHistory(history : [Bool]) -> Bool {
        var onlyHits = true
        for hit in history {
            if !hit {
                onlyHits = false
            }
        }
        return onlyHits
    }
}
