//
//  IoTFeverGameService.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class IoTFeverGameService {
    
    class func start(username: String){
      
        var player = Player( name: username)
        var timer = Timer()
        
        EntityManager.sharedInstance.add(IoTFeverGame(player: player))
    }
    
    class func isAHit(move: Move) -> Bool{
       
        return true
    }
    
    class func isCompleted() -> Bool {
        
        return true
    }
}
