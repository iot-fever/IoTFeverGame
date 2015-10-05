//
//  User.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 5/10/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class User {
    var nickname    : String?
    var running     : Bool
    
    init(running : Bool) {
        self.running = running
    }
}