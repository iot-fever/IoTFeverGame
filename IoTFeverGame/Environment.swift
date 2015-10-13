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
    var rankingService  : RankingServiceProtocol
    var username        : String

    
    init(sensorService : SensorServiceProtocol, rankingService : RankingServiceProtocol, username : String) {
        self.sensorService  = sensorService
        self.rankingService = rankingService
        self.username       = username
    }
}

var configuration : ConfigurationProtocol?

protocol ConfigurationProtocol {
    
    func getUserProtocol()       -> UserServiceProtocol
    func getSensorProtocol()     -> SensorServiceProtocol
    func getRankingService()     -> RankingServiceProtocol
}


class TestConfiguration : ConfigurationProtocol {
    
    func getUserProtocol()          -> UserServiceProtocol {
        return DummyUserService()
    }
    
    func getSensorProtocol()        -> SensorServiceProtocol {
        return DummySensorService()
    }
    
    func getRankingService()        -> RankingServiceProtocol {
        return DummyRankingService()
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
    
    func getUserProtocol()          -> UserServiceProtocol    {
        return DummyUserService()
    }
    
    func getSensorProtocol()        -> SensorServiceProtocol  {
        return IntegratedSensorService.current
    }
    
    func getRankingService()        -> RankingServiceProtocol {
        return RemoteRankingService()
    }
}

class KuraConfiguration : NSObject, ConfigurationProtocol {
    
    func getUserProtocol()          -> UserServiceProtocol    {
        return DummyUserService()
    }
    
    func getSensorProtocol()        -> SensorServiceProtocol  {
        return MqttSensorService.current
    }
    
    func getRankingService()        -> RankingServiceProtocol {
        return KuraRankingService()
    }
}



