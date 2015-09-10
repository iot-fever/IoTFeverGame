//
//  Timer.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class Timer: NSObject {
   
    var subscribers     = [GameSubscribe]()
    
    var duration    : Double = 90
    var frequence   : Double = 1
    
    override init(){
        super.init()
        
        schedule()
    }
    
    // Protocol - Game Subscribe - Implementation
    func subscribe(vc: GameSubscribe) {
        self.subscribers.append(vc)
    }
    
    func publish() {
        for vc in self.subscribers {
            vc.started()
        }
    }
    
   
}
