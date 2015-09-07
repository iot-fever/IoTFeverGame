//
//  MoveService.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class MoveService {

    static func getNextRandomMove() -> Move {
        
        return EntityManager.entityManager.get().runningLevel.moves[Int(arc4random_uniform(7) + 0)]
    }
    
    func getMove (x: Int, y: Int) {
    
    }
}