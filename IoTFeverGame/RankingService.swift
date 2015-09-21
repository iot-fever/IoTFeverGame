//
//  RankingService.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 15/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

protocol RankingService {
    
    func publish(player : Player)
}

class DummyRankingService : RankingService {
    
    func publish(player : Player) {
        
    }
}

class RemoteRankingService : RankingService {
    
    let postURL : String = "http://192.168.1.32:1337/highscore/vorto"
    
    func publish(player : Player) {
        println("Post Highscore")
        
        var postsUrlRequest = NSMutableURLRequest(URL: NSURL(string: postURL )!)
        postsUrlRequest.HTTPMethod = "POST"
        
        // static calculation of highscore
        var newPost: NSDictionary = ["score": (player.score * 4)];
        var postJSONError: NSError?
        var jsonPost = NSJSONSerialization.dataWithJSONObject(newPost, options: nil, error:  &postJSONError)
        postsUrlRequest.HTTPBody = jsonPost
        postsUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        NSURLConnection.sendAsynchronousRequest(postsUrlRequest, queue: NSOperationQueue(), completionHandler:{
            (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if let anError = error {
                // got an error in getting the data, need to handle it
                println("error calling POST")
            }
            else
            {
                // parse the result as json, since that's what the API provides
                var jsonError: NSError?
                let post = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as! NSDictionary
                if let aJSONError = jsonError
                {
                    // got an error while parsing the data, need to handle it
                    println("error parsing response from POST")
                }
                else
                {
                    // we should get the post back, so print it to make sure all the fields are as we set to and see the id
                    println("The post is: " + post.description)
                }
            }
        })

    }
}
