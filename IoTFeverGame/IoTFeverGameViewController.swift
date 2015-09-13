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

class IoTFeverGameViewController: UIViewController, IOTFeverDataAware, AnyObject {
    
    var hitMessages : [String] = ["Whatta move!",
                                  "You're on fire!",
                                  "It's getting hot in here"]
    
    var missMessages : [String] = ["Oops",
                                   "Ouch!",
                                   "Ain't your day huh"]
    
    // MARK: UI Properties
    @IBOutlet weak var score                : UILabel!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Subscriber
        currentGame = IoTFeverGame(username:"Andreas")
        let firstLevel = currentGame.start()
        self.timeCountLabel.text = String(firstLevel.duration)
        validateLastAndCreateNewMove()
        scheduleLevelTimers(firstLevel)

        subscribeToSensorDataStream()
    }
    
    func subscribeToSensorDataStream() {
        NSTimer.scheduledTimerWithTimeInterval(1.00, target: self, selector: Selector("generateSensorDataFromDevice1"), userInfo: nil, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(1.00, target: self, selector: Selector("generateSensorDataFromDevice2"), userInfo: nil, repeats: true)
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
            validateLastAndCreateNewMove()
            scheduleLevelTimers(nextLevel)
        } else {
            currentGame.stopGame()
            renderGameOverSuccessful()
        }
    }
    
    func renderGameOverSuccessful() {
        self.GameOver.text = "You won!"
    }
    
    func renderGameOverUnsuccessful() {
        self.GameOver.text = "You lost! Maybe next time."
    }
    
    func validateLastAndCreateNewMove() {
        var currentLevel = currentGame.getCurrentLevel()
        var currentMove = currentLevel.currentMove
        if (currentMove != nil && !currentMove!.isSuccessful()) {
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
        currentLevel.newMove()
        self.imageView.image = UIImage(named: currentLevel.currentMove!.getImage())
    }
    
    func hideLifeInUI(lifeImage: UIImageView) {
        lifeImage.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Protocol IOTFeverDataAware
    func onDataIncoming(data: [Double]) {
       // process data from sensors. TODO: get identifier for sensor left and sensor right arm
    }
    
    func generateSensorDataFromDevice1() {
        var dummySensor = DummySensor()
        if (currentGame.isRunning) {
            var currentMove = currentGame.getCurrentLevel().currentMove as! TwoStepMove
            
            currentMove.firstMove!.makeMove(dummySensor.generateData())
            if (currentMove.isSuccessful()) {
                currentGame.increaseHits()
                self.score.text = String(currentGame.totalHits())
                flashGreen()
            }
        }

    }
    
    func generateSensorDataFromDevice2() {
        var dummySensor = DummySensor()
        if (currentGame.isRunning) {
            var currentMove = currentGame.getCurrentLevel().currentMove as! TwoStepMove
            
            currentMove.secondMove!.makeMove(dummySensor.generateData())
             if (currentMove.isSuccessful()) {
                currentGame.increaseHits()
                self.score.text = String(currentGame.totalHits())
                flashGreen()
            }
        }
        
    }

    
    func flashGreen() {
        let result = Int(arc4random_uniform(UInt32(self.hitMessages.count)))
        self.GameOver.text = hitMessages[result]
    }
    
    func flashRed() {
        let result = Int(arc4random_uniform(UInt32(self.missMessages.count)))
        self.GameOver.text = missMessages[result]
    }
    
    func levelCountdown() {
        self.timeCountLabel.text = String(currentGame.getCurrentLevel().duration--)
    }
}
