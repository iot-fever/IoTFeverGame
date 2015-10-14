//
//  RankingService.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 15/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

protocol RankingServiceProtocol {
    
    func publish(player : Player)
}

class DummyRankingService : RankingServiceProtocol {
    
    func publish(player : Player) {
        
    }
}

class RemoteRankingService : RankingServiceProtocol {
    
    let postURL : String = "http://192.168.1.32:1337/highscore/vorto"
    
    func publish(player : Player) {
        print("Post Highscore")
        
//        var postsUrlRequest = NSMutableURLRequest(URL: NSURL(string: postURL )!)
//        postsUrlRequest.HTTPMethod = "POST"
//        
//        // static calculation of highscore
//        var newPost: NSDictionary = ["score": (player.score * 4)];
//        var postJSONError: NSError?
//        
//        do {
//            var jsonPost = try NSJSONSerialization.dataWithJSONObject(newPost, options: nil)
//            
//            postsUrlRequest.HTTPBody = jsonPost
//            postsUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            try NSURLConnection.sendAsynchronousRequest(postsUrlRequest, queue: NSOperationQueue(), completionHandler: {
//                (response:NSURLResponse!, data: NSData!) -> Void in
//                
//                let post = try NSJSONSerialization.JSONObjectWithData(data, options: nil) as! NSDictionary
//            })
//
//        } catch let error as ErrorType {
//            print("Error \(error)")
//        }
        
    }
}

class KuraRankingService : RankingServiceProtocol {
    
    func publish(player : Player) {
        ScoreRanking.current.addInRanking(player)
    }
}
