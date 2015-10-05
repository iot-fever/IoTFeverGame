//
//  Environment.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 15/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class GameEnvironment {
    
    var sensorService   : SensorServiceProtocol
    var username        : String
    
    init(sensorService : SensorServiceProtocol, username : String) {
        self.sensorService  = sensorService
        self.username       = username
    }
}

var configuration : Configuration?

protocol Configuration {
    
    func getUserService()       -> UserServiceProtocol
    func getSensorService()     -> SensorServiceProtocol
}


class TestConfiguration : Configuration {
    
    func getUserService()       -> UserServiceProtocol {
        return DummyUserService()
    }
    
    func getSensorService()     -> SensorServiceProtocol {
        return DummySensorService()
    }
}

class DummyUserService : UserServiceProtocol {
    
    func getUser() {
        user            = User(running: true)
        user.nickname   = "Alex"
    }
}

class IntegratedConfiguration : NSObject, Configuration {
    
    func getUserService()       -> UserServiceProtocol    {
        return DummyUserService()
    }
    
    func getSensorService()     -> SensorServiceProtocol  {
        return SensorTagAdapterService.current
    }
}



