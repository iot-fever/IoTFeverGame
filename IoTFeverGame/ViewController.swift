//
//  ViewController.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 2/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import UIKit

var username: String = ""

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var playerNameText   : UILabel!
    
    var discoBall : UIImageView = UIImageView()
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        
        self.playerNameText.text = "Waiting for User ..."
        
        let url = NSBundle.mainBundle().URLForResource("disco-anim", withExtension: "gif");
        let gif = UIImage.animatedImageWithAnimatedGIFURL(url)
        
        let screenSize = UIScreen.mainScreen().bounds
        discoBall.image = gif
        discoBall.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)

        self.view.addSubview(discoBall)
        self.view.sendSubviewToBack(discoBall)
        self.view.backgroundColor = UIColor.brownColor()
        
        super.viewDidLoad()
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("getUsername:"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUsername(timer: NSTimer){
        println("Get Username")
        
        var urlRequest = NSURLRequest(URL: NSURL(string: "http://192.168.1.32:1337/station/Vorto")!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue(), completionHandler:{
            (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if let anError = error
            {
                // got an error in getting the data, need to handle it
                println("error calling GET")
            }
            else // no error returned by URL request
            {
                // parse the result as json, since that's what the API provides
                var jsonError: NSError?
                let post = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as! NSDictionary
                if let aJSONError = jsonError
                {
                    // got an error while parsing the data, need to handle it
                    println("error parsing data")
                }
                else
                {
                    if post["status"])
                    if var postUser = post["user"] as? NSDictionary
                    {
                        if var nickname = postUser["nickname"] as? String{
                            println("The nickname is: " + nickname)
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                username = nickname
                                self.playerNameText.text = "Hi, " + username
                            
                                timer.invalidate()
                            self.performSegueWithIdentifier("countdownIdentifier", sender: self)
                                
                            });
                        }
                        
                    }
                    
                    
                }
            }
        })
    }
    
    
}

