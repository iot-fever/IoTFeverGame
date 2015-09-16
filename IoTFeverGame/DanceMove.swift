//
//  Move.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 13/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

protocol DanceMove : AnyObject {
    
    func getImage() -> String
    
    func getInvolvedBodyParts() -> [MovingBodyPart]
    
    func isCompleted() -> Bool
}

protocol MovingBodyPart {
    
    func isCompleted() -> Bool
    
    func mimic(data : [Double])
    
    func getImage() -> String
}