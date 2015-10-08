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

var configuration : ConfigurationProtocol?

protocol ConfigurationProtocol {
    
    func getUserProtocol()       -> UserServiceProtocol
    func getSensorProtocol()     -> SensorServiceProtocol
}


class TestConfiguration : ConfigurationProtocol {
    
    func getUserProtocol()       -> UserServiceProtocol {
        return DummyUserService()
    }
    
    func getSensorProtocol()     -> SensorServiceProtocol {
        return DummySensorService()
    }
}

class DummyUserService : UserServiceProtocol {
    
    func getUser() {
        user            = User(running: true)
        user.nickname   = "Alex"
        print("Got User Alex")
    }
}

class IntegratedConfiguration : NSObject, ConfigurationProtocol {
    
    func getUserProtocol()       -> UserServiceProtocol    {
        return DummyUserService()
    }
    
    func getSensorProtocol()     -> SensorServiceProtocol  {
        return SensorService.current
    }
}



