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

var currentGame                         : IoTFeverGame!

class IoTFeverGameViewController: UIViewController, SensorDataListener, AnyObject {
    
    var hitMessages : [String] = ["Whatta move!",
                                  "You're on fire!",
                                  "It's getting hot in here",
                                  "Groooovy"]
    
    var missMessages : [String] = ["Oops",
                                   "Ouch!",
                                   "Ain't your day huh",
                                   "You call that dancing?" ]
    
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
    
    @IBOutlet weak var lblUsername  : UILabel!
    @IBOutlet weak var lblCountDown : UILabel!
    @IBOutlet weak var lblgetReady: UILabel!

    
    var gameTimer : NSTimer?
    var levelTimer: NSTimer?
    var moveTimer : NSTimer?
    var countdownTimer : NSTimer?
    
    var emitterLayer : CAEmitterLayer?
    let vizView = VisualizerView()
    
    var countdown : Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCountdown()
        
        view.backgroundColor = UIColor.blackColor()

    }
    
    func showCountdown(){
        self.lblUsername.text =  "Hi \(user.nickname!)"
        self.lblCountDown.text = String(countdown)
        countdown--
        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateCountDown"), userInfo: nil, repeats: true)
    }
    func updateCountDown() {
        if(countdown > 0) {
            self.lblCountDown.text = String(countdown--)
        } else {
            countdownTimer!.invalidate()
            self.lblCountDown.hidden = true
            self.lblUsername.hidden = true
            self.lblgetReady.hidden = true
            startRealGame()
        }
    }
    
    func startRealGame(){
        let sensorService = configuration!.getSensorService()
        sensorService.subscribe(self)
        
        currentGame = IoTFeverGame(username: user.nickname!)
        let firstLevel = currentGame.start()
        self.timeCountLabel.text = String(firstLevel.duration)
        createNewMove(firstLevel)
        scheduleLevelTimers(firstLevel)
        
        // Visualizer
        
        vizView.backgroundColor = UIColor.blackColor()
        
        
        self.view.addSubview(vizView)
        self.view.sendSubviewToBack(vizView)
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
            renderGameOver()
        }
    }
    
    func renderGameOver() {
        vizView.stopAudio()
        self.performSegueWithIdentifier("gameEndIdentifier", sender: self)
    }
    
    func validateLastAndCreateNewMove() {
        var currentLevel = currentGame.getCurrentLevel()
        if (!currentLevel.currentMove.isCompleted()) {
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
            renderGameOver()
            return
        }
    }
    
    func flashBulb(color: Int) {
        
        // MQTTKit Example
        
        
        var mqttInstance :MQTTClient!
        var bulbTopic = "$EDC/iot-fever/20BA/iotfever/lights/1/state"
        
        var clientID = UIDevice.currentDevice().identifierForVendor.UUIDString
        mqttInstance = MQTTClient(clientId: clientID)
        let kMQTTServerHost = "192.168.1.39"
        
        mqttInstance.connectToHost(kMQTTServerHost, completionHandler: { (code: MQTTConnectionReturnCode) -> Void in
            if code.value == ConnectionAccepted.value {
                println("CONNECTED")
                // RED
                if color == 0 {
                    if  mqttInstance.connected {
                        mqttInstance.publishString("miss", toTopic: bulbTopic, withQos: ExactlyOnce, retain: false, completionHandler: { mid in

                        })
                    }
                    
                } // GREEN
                else {
                    if  mqttInstance.connected {
                        mqttInstance.publishString("hit", toTopic: bulbTopic, withQos: ExactlyOnce, retain: false, completionHandler: { mid in

                        })
                    }
                }
            } else {
                println("return code \(code.value)")
            }
        })
    }
    
    func flashRed() {
        let result = Int(arc4random_uniform(UInt32(self.missMessages.count)))
        
        var indicatorView = UIView()
        indicatorView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        indicatorView.backgroundColor = UIColor.redColor()
        self.view.addSubview(indicatorView)
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            indicatorView.alpha = 0.5
        }, completion: {
            (value: Bool) in
            UIView.animateWithDuration(0.3, delay: 0, options:UIViewAnimationOptions.CurveEaseOut, animations:{
                indicatorView.alpha = 0
            }, completion: {
                (value: Bool) in
                indicatorView.removeFromSuperview()
            })
        })
        self.flashBulb(0)
        self.GameOver.text = missMessages[result]
    }
    
    func isHit() {
        var indicatorView = UIView()
        indicatorView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        indicatorView.backgroundColor = UIColor.greenColor()
        self.view.addSubview(indicatorView)
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            indicatorView.alpha = 0.5
            }, completion: {
                (value: Bool) in
                UIView.animateWithDuration(0.3, delay: 0, options:UIViewAnimationOptions.CurveEaseOut, animations:{
                    indicatorView.alpha = 0
                    }, completion: {
                        (value: Bool) in
                        indicatorView.removeFromSuperview()
                })
        })
        
        
        currentGame.increaseHits()
        self.score.text = String(currentGame.player.score)
        self.bonusPoints.text = String(currentGame.player.bonus)
        flashGreen()
    }
    
    func flashGreen() {
        println("FLASH GREEN!")
        self.flashBulb(1)
        let result = Int(arc4random_uniform(UInt32(self.hitMessages.count)))
        self.GameOver.text = hitMessages[result]
    }
    
    func createNewMove(level : Level) {
        level.newMove()
        self.imageView.image = UIImage(named: level.currentMove.getImage()+".png")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onDataRightIncoming(data: [Double]) {
        if (currentGame.isRunning) {
            var currentMove = currentGame.getCurrentLevel().currentMove
            
            for bodyPart in currentMove.getInvolvedBodyParts() {
                if bodyPart is MovingArmBodyPart {
                    if (bodyPart as! MovingArmBodyPart).rightSide {
                        bodyPart.mimic(data)
                    }
                    
                }
            }
        }
    }
    
    func onDataLeftIncoming(data: [Double]) {
        if (currentGame.isRunning) {
            var currentMove = currentGame.getCurrentLevel().currentMove
            
            for bodyPart in currentMove.getInvolvedBodyParts() {
                if bodyPart is MovingArmBodyPart {
                    if (bodyPart as! MovingArmBodyPart).rightSide == false {
                        bodyPart.mimic(data)
                    }
                    
                }
            }
        }
    }
    
    func levelCountdown() {
        self.timeCountLabel.text = String(currentGame.getCurrentLevel().duration--)
    }
}
