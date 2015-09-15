//
//  IoTFeverGameViewController.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 3/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import UIKit
import CoreData
import CoreBluetooth
import AVFoundation

class IoTFeverGameViewController: UIViewController, IOTFeverDataAware, AnyObject {
    
    var hitMessages : [String] = ["Whatta move!",
                                  "You're on fire!",
                                  "It's getting hot in here"]
    
    var missMessages : [String] = ["Oops",
                                   "Ouch!",
                                   "Ain't your day huh"]
    
    // MARK: UI Properties
    @IBOutlet weak var score                : UILabel!
    @IBOutlet weak var bonusPoints          : UILabel!
    @IBOutlet weak var try1Image            : UIImageView!
    @IBOutlet weak var try2Image            : UIImageView!
    @IBOutlet weak var try3Image            : UIImageView!
    
    @IBOutlet weak var imageView            : UIImageView!
    
    @IBOutlet weak var timeLabel            : UILabel!
    @IBOutlet weak var timeCountLabel       : UILabel!
    
    @IBOutlet weak var levelLabel           : UILabel!
    @IBOutlet weak var levelAmountLabel     : UILabel!
    
    @IBOutlet weak var GameOver             : UILabel!
    
    var currentGame                         : IoTFeverGame!
    
    var gameTimer : NSTimer?
    var levelTimer: NSTimer?
    var moveTimer : NSTimer?
    
    var emitterLayer : CAEmitterLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Subscriber
        currentGame = IoTFeverGame(username: username)
        let firstLevel = currentGame.start()
        self.timeCountLabel.text = String(firstLevel.duration)
        createNewMove(firstLevel)
        scheduleLevelTimers(firstLevel)

        subscribeToSensorDataStream()
        
        // Visualizer
        let vizView = VisualizerView()
        vizView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(vizView)
        self.view.sendSubviewToBack(vizView)    
    }
            
    func subscribeToSensorDataStream() {
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("generateSensorDataFromDeviceRightArm"), userInfo: nil, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("generateSensorDataFromDeviceLeftArm"), userInfo: nil, repeats: true)
        //sensorDelegate.subscribe(self)
    }
    
    func scheduleLevelTimers(level : Level) {
         // starts level Countdown timer
         gameTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("levelCountdown"), userInfo: nil, repeats: true)
         // starts Level duration timer
         levelTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(level.duration+1), target: self, selector: Selector("levelEnded"), userInfo: nil, repeats: true)
         // starts Move change timer
         moveTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(level.delayBetweenMoves), target: self, selector: Selector("validateLastAndCreateNewMove"), userInfo: nil, repeats: true)
    }
    
    func unscheduleTimers() {
        gameTimer!.invalidate()
        levelTimer!.invalidate()
        moveTimer!.invalidate()
    }
    
    func levelEnded() {
        unscheduleTimers()
        if (currentGame.hasNextLevel()) {
            let nextLevel = currentGame.getNextLevel()
            levelAmountLabel.text = String(nextLevel.name)
            createNewMove(nextLevel)
            scheduleLevelTimers(nextLevel)
        } else {
            currentGame.stopGame()
            renderGameOverSuccessful()
        }
    }
    
    func renderGameOverSuccessful() {
        self.GameOver.text = "You won!"
        //TODO replace with Publisher (Protocol)
        PostHighscore(currentGame.player.score)
    }
    
    func renderGameOverUnsuccessful() {
        let hulk = UIImageView()
        
        let url = NSBundle.mainBundle().URLForResource("hulk-disco", withExtension: "gif");
        let gif = UIImage.animatedImageWithAnimatedGIFURL(url)
        
        let screenSize = UIScreen.mainScreen().bounds
        hulk.image = gif
        hulk.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        
        self.view.addSubview(hulk)
        self.view.bringSubviewToFront(hulk)
        self.GameOver.text = "You lost! Maybe next time."
        
        //TODO replace with Publisher (Protocol)
        PostHighscore(currentGame.player.score)
    }
    
    func validateLastAndCreateNewMove() {
        var currentLevel = currentGame.getCurrentLevel()
        if (!currentLevel.currentMove!.isCompleted()) {
            isMiss()
        } else {
            isHit()
        }
        createNewMove(currentLevel)
    }
    
    func isMiss() {
        flashRed()
        currentGame.player.deductLive()
        var livesLeft = currentGame.player.lives
        if (livesLeft == 2) {
            self.try3Image.hidden = true
        } else if (livesLeft == 1) {
            self.try2Image.hidden = true
        } else {
            self.try1Image.hidden = true
            currentGame.stopGame()
            unscheduleTimers()
            renderGameOverUnsuccessful()
            return
        }
    }
    
    func flashRed() {
        let result = Int(arc4random_uniform(UInt32(self.missMessages.count)))
        self.GameOver.text = missMessages[result]
    }
    
    func isHit() {
        currentGame.increaseHits()
        self.score.text = String(currentGame.player.score)
        self.bonusPoints.text = String(currentGame.player.bonus)
        flashGreen()
    }
    
    func flashGreen() {
        let result = Int(arc4random_uniform(UInt32(self.hitMessages.count)))
        self.GameOver.text = hitMessages[result]
    }
    
    func createNewMove(level : Level) {
        level.newMove()
        self.imageView.image = UIImage(named: level.currentMove!.getImage())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Protocol IOTFeverDataAware
    func onDataRightIncoming(data: [Double]) {
       // process data from RIGHT sensors. TODO: get identifier for sensor left and sensor right arm
        if (currentGame.isRunning) {
            var currentMove = currentGame.getCurrentLevel().currentMove as! TwoStepMove
            currentMove.rightArm.mimicMove(data)
        }
    }
    
    func onDataLeftIncoming(data: [Double]) {
        // process data from LEFT sensors. TODO: get identifier for sensor left and sensor right arm
        if (currentGame.isRunning) {
            var currentMove = currentGame.getCurrentLevel().currentMove as! TwoStepMove
            currentMove.rightArm.mimicMove(data)
        }
    }
    
    func generateSensorDataFromDeviceRightArm() {
        var dummySensor = DummySensor()
        if (currentGame.isRunning) {
            var currentMove = currentGame.getCurrentLevel().currentMove as! TwoStepMove
            currentMove.rightArm.mimicMove(dummySensor.generateData())
        }
    }
    
    func generateSensorDataFromDeviceLeftArm() {
        var dummySensor = DummySensor()
        if (currentGame.isRunning) {
            var currentMove = currentGame.getCurrentLevel().currentMove as! TwoStepMove
            currentMove.leftArm.mimicMove(dummySensor.generateData())
        }
        
    }
  
    func levelCountdown() {
        self.timeCountLabel.text = String(currentGame.getCurrentLevel().duration--)
    }
    
    func PostHighscore(score : Int){
        println("Post Highscore")
        
        var postsUrlRequest = NSMutableURLRequest(URL: NSURL(string: "http://192.168.1.32:1337/highscore/vorto"
)!)
        postsUrlRequest.HTTPMethod = "POST"
        
        var newPost: NSDictionary = ["score": score];
        var postJSONError: NSError?
        var jsonPost = NSJSONSerialization.dataWithJSONObject(newPost, options: nil, error:  &postJSONError)
        postsUrlRequest.HTTPBody = jsonPost
        postsUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        NSURLConnection.sendAsynchronousRequest(postsUrlRequest, queue: NSOperationQueue(), completionHandler:{
            (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if let anError = error
            {
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
