//
//  Environment.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 15/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class GameEnvironment {
    
    var sensorService   : SensorService
    var username        : String
    
    init(sensorService : SensorService, username : String) {
        self.sensorService  = sensorService
        self.username       = username
    }
}

var configuration : Configuration?

protocol Configuration {
    
    func getUserService()       -> UserService
    func getSensorService()     -> SensorService
}


class TestConfiguration : Configuration {
    
    func getUserService()       -> UserService {
        return DummyUserService()
    }
    
    func getSensorService()     -> SensorService {
        return DummySensorService()
    }
}

class DummyUserService : UserService {
    
    func getUser() {
        user            = User(running: true)
        user.nickname   = "Alex"
    }
}

class IntegratedConfiguration : NSObject, Configuration {
    
    
    func getUserService()       -> UserService    {
        return DummyUserService()
    }
    
    func getSensorService()     -> SensorService  {
        return SensorTagAdapterService.current
    }
}



