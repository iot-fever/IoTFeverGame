//
//  MoveService.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class MoveService: IOTFeverDataAware {
    
    func validateMove (move: Move) {
        sensorDelegate.subscribe(self)
        // timer - 3s 
        
        
        
    }
    
    func onDataIncoming(data: [Double]) {
        
        println("We got some data here!!")
        
        
        for value in data {
            println("test \(value)")
        }
    }
}