//
//  EntityManager.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

    
class EntityManager {
    static let sharedInstance = EntityManager()
    
    var game: [IoTFeverGame] = [IoTFeverGame]()
    
    // METHODS
    private init() {

    }
    
    func add (game: IoTFeverGame) {
        self.game.append(game)
    }
    
    func get () -> IoTFeverGame {
        if game.count < 1 {
            
           // var timer = Timer()
        
           // EntityManager.sharedInstance.add(IoTFeverGame(username: "test"))
        }
        return self.game[0]
    }
}