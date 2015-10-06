//
//  DanceMoveProtocol.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 6/10/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

protocol DanceMoveProtocol : AnyObject {
    
    func getImage() -> String
    
    func getInvolvedBodyParts() -> [MovingBodyPartProtocol]
    
    func isCompleted() -> Bool
    
    func reset()
}