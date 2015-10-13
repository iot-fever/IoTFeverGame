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
    
    init(){
        self.players = [Player] ()
    }
    
    func getTop(amount: Int) -> [Player]{
        
        var topPlayer = [Player]()
    
        players!.sortInPlace{ $0.name < $1.name }

        for index in 1...amount {
            topPlayer.append(players![index])
        }
        
        return topPlayer
    }
}