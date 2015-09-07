//
//  IoTFeverGameService.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class IoTFeverGameService {
    
    static func start(username: String){
      
        var player = Player(calibrateValue: 0, name: username)
        var timer = Timer()
        
        EntityManager.entityManager.add(IoTFeverGame(player: player, timer: timer))
    }
    
    func getCurrentLevel() -> Level{
    
        return EntityManager.entityManager.get().runningLevel
    }
    
    func isAHit(move: Move) -> Bool{
       
        return true
    }
    
    func isCompleted() -> Bool {
        
        return true
    }
}
