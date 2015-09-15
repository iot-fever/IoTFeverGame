//
//  GameEnd.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 15/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import UIKit

class GameEndViewController : UIViewController {

    
    @IBOutlet weak var lblResult        : UILabel!
    @IBOutlet weak var lblScore         : UILabel!
    @IBOutlet weak var lblScoreResult   : UILabel!
    
    let postURL : String = "http://192.168.1.32:1337/highscore/vorto"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentGame.player.score == 100 {
            self.lblResult.text = "You Won!!"
        } else {
            self.lblResult.text = "Game Over!!"
        }
        
        self.lblScoreResult.text = String(currentGame.player.score)
        
        // TODO replace with Publisher (Protocol)
        PostHighscore(currentGame.player.score)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func PostHighscore(score : Int){
        println("Post Highscore")
        
        var postsUrlRequest = NSMutableURLRequest(URL: NSURL(string: postURL )!)
        postsUrlRequest.HTTPMethod = "POST"
        
        var newPost: NSDictionary = ["score": score];
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
