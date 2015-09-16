//
//  Environment.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 15/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class GameEnvironment {
    
    var sensorService : SensorService
    var rankingService : RankingService
    var username : String
    
    init(sensorService : SensorService, rankingService : RankingService, username : String) {
        self.sensorService = sensorService
        self.rankingService = rankingService
        self.username = username
    }
}

var configuration : Configuration?

protocol Configuration {
    
    func canStartGame(startGame:(GameEnvironment) -> ())
}


class TestConfiguration : Configuration {
    
    func canStartGame(startGame:(GameEnvironment) -> ()) {
        startGame(GameEnvironment(sensorService: DummySensorService(),rankingService : DummyRankingService(), username: "Alex"))
    }
}

class IntegratedConfiguration : NSObject, Configuration {
    
    let requestURL : String = "http://192.168.1.32:1337/station/Vorto"
    
    var startGame:((GameEnvironment)->Void)?
    
    func canStartGame(startGame: (GameEnvironment) -> ()) {
        self.startGame = startGame
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("getUsername:"), userInfo: nil, repeats: true)
    }
    
    //tries to get the username from a remote service, if successful it calls the game to start
    func getUsername(timer : NSTimer) {
        var urlRequest = NSURLRequest(URL: NSURL(string: requestURL)!)
        println("get Username")
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue(), completionHandler:{
            (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if let anError = error {
                // got an error in getting the data, need to handle it
                println("error calling GET")
            } else {
                // parse the result as json, since that's what the API provides
                var jsonError: NSError?
                let post = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as! NSDictionary
                if let aJSONError = jsonError {
                    // got an error while parsing the data, need to handle it
                    println("error parsing data")
                } else {
                    //if post["status"] as? String == "Running" {
                        if var postUser = post["user"] as? NSDictionary {
                            if var nickname = postUser["nickname"] as? String{
                                println("The nickname is: " + nickname)
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    timer.invalidate()
                                    self.startGame!(GameEnvironment(sensorService: SensorTagAdapterService(),rankingService : RemoteRankingService(), username: nickname))
                                });
                            }
                        }
                    //}
                    
                }
            }
        })
    }
}



