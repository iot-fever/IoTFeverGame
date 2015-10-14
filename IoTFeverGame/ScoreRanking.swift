//
//  ScoreRanking.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class ScoreRanking {

    static let current : ScoreRanking = ScoreRanking()
    
    var players: [Player]?
    
    private init(){
        self.players = [Player] ()
    }
    
    func addInRanking(player: Player) {
        
        players!.append(player)
        
        players!.sortInPlace({
            $0.score > $1.score
        })
    }
}