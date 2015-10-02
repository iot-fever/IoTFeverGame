//
//  UserService.swift
//  IoTFeverGame
//
//  Created by Mueller Cornelius on 17/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

protocol UserService {
    
    func getUser()
}

class User {
    var nickname    : String?
    var running     :  Bool
    
    init(running : Bool) {
        self.running = running
    }
}