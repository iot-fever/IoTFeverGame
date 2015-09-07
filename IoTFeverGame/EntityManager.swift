//
//  EntityManager.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class EntityManager {
    
    static var game = [IoTFeverGame]()
    
    static func add(game: IoTFeverGame){
        self.game.append(game)
    }
    
    static func get() -> IoTFeverGame {
        return game[0]
    }

}