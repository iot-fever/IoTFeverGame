//
//  ViewController.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 2/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import UIKit

var user : User = User(running: false)
var gameStarted : Bool = false

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var playerNameText       : UILabel!
    @IBOutlet weak var IVPlayerReceived     : UIImageView!
    @IBOutlet weak var IVSensorLeftFound    : UIImageView!
    @IBOutlet weak var IVSensorRightFound   : UIImageView!
    
    var discoBall : UIImageView = UIImageView()
    
    var timer : NSTimer?
    
    func startGame() {
        timer!.invalidate()
        if !gameStarted {
            gameStarted = true
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier("startGameIdentifier", sender: self)
            });
        }
    }

    
    override func viewDidLoad() {
        self.playerNameText.text = "Waiting for new Game..."
        
        self.IVPlayerReceived.image = UIImage(named: "button-stop.png")

        setSensorStatus()
        
        let url = NSBundle.mainBundle().URLForResource("disco-anim", withExtension: "gif");
        let gif = UIImage.animatedImageWithAnimatedGIFURL(url)
        
        let screenSize = UIScreen.mainScreen().bounds
        discoBall.image = gif
        discoBall.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        discoBall.contentMode = UIViewContentMode.ScaleAspectFill

        self.view.addSubview(discoBall)
        self.view.sendSubviewToBack(discoBall)
        self.view.backgroundColor = UIColor.brownColor()
                
        super.viewDidLoad()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("checkUserAndSensortag"), userInfo: nil, repeats: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func checkUserAndSensortag(){

        configuration!.getUserService().getUser()
        
        setSensorStatus()
        
        if (user.running) {
            self.IVPlayerReceived.image = UIImage(named: "button-start.png")
            
            if (!configuration!.getSensorService().isConnected()) {
                configuration!.getSensorService().connect(startGame)
            } else {
                startGame()
            }
        } else {
            self.IVPlayerReceived.image = UIImage(named: "button-stop.png")
        }
    }
    
    func setSensorStatus(){
     
        if (configuration!.getSensorService().sensorRightStatus()) {
            self.IVSensorRightFound.image = UIImage(named: "button-start.png")
        } else {
            self.IVSensorRightFound.image = UIImage(named: "button-stop.png")
        }
        
        if (configuration!.getSensorService().sensorLeftStatus()) {
            self.IVSensorLeftFound.image = UIImage(named: "button-start.png")
        } else {
            self.IVSensorLeftFound.image = UIImage(named: "button-stop.png")
        }
    }
    

}

