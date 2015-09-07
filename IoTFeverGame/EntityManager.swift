//
//  EntityManager.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class EntityManager {
    static let entityManager = EntityManager()
    
    var game = [IoTFeverGame]()
    
    // METHODS
    private init() {
        println(__FUNCTION__)
    }
    
    func add(game: IoTFeverGame){
        self.game.append(game)
    }
    
    func get() -> IoTFeverGame {
        return game[0]
    }

}