//
//  Move.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 13/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

protocol MovingBodyPartProtocol {
    
    func isCompleted() -> Bool
    
    func mimic(data : Float)
    
    func getImage() -> String
    
    func reset()
}