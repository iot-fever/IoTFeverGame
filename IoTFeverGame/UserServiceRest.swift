//
//  UserServiceRest.swift
//  IoTFeverGame
//
//  Created by Mueller Cornelius on 17/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class UserServiceRest : UserService {
    
    let requestURL : String = "http://192.168.1.32:1337/station/Vorto"
    
    func getUser() {
        
        var urlRequest = NSURLRequest(URL: NSURL(string: requestURL)!)
        println("get Username from REST Server ...")
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue(), completionHandler:{
            (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if let anError = error {
                println("Got error back from server.")
            } else {
                var jsonError: NSError?
                let post = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as! NSDictionary
                if let aJSONError = jsonError {
                    println("error parsing data")
                } else {
//                    if post["status"] as? String == "Running" {
//                        user = User(running: true)
//                        var postUser = post["user"] as! NSDictionary
//                        user.nickname = postUser["nickname"] as? String
//                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if post["status"] as? String == "Running" {
                            user.running = true
                            var postUser = post["user"] as! NSDictionary
                            user.nickname = postUser["nickname"] as? String
                        }
                    });
                    
                    
                }
            }
        })
    }

}
