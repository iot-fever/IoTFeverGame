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

class StartViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var playerNameText       : UILabel!
    @IBOutlet weak var IVPlayerReceived     : UIImageView!
    @IBOutlet weak var IVSensorLeftFound    : UIImageView!
    @IBOutlet weak var IVSensorRightFound   : UIImageView!
    @IBOutlet weak var txtVUsername         : UITextField!
    @IBOutlet weak var btnStartGame         : UIButton!
    @IBOutlet weak var lblWaitingforUser    : UILabel!
    @IBOutlet weak var lblEnterUsername     : UILabel!
    
    // static name for status images
    let startButton         : String        = "button-start.png"
    let stopButton          : String        = "button-stop.png"
    
    var discoBall           : UIImageView   = UIImageView()
    
    var timer               : NSTimer?
    var frequencyConnection : NSTimer?
    
    // kura and test mode
    @IBAction func registerUser(sender: AnyObject) {
        checkUserAndSensortag()
    }
    
    // starts segue to GameViewController.swift
    func startGame() {
        if (timer != nil) {
            timer!.invalidate()
        }
        
        if !gameStarted {
            gameStarted = true
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier("startGameIdentifier", sender: self)
            });
        }
    }
    
    override func viewDidLoad() {
        
        // necessary check and set Start Status configuration
            self.IVPlayerReceived.image             = UIImage(named: stopButton)
            self.IVSensorRightFound.image           = UIImage(named: stopButton)
            self.IVSensorLeftFound.image            = UIImage(named: stopButton)
        
        // necessary inilization
            gameStarted     = false
            user.running    = false
        
        // connect alredy async
            if !configuration!.getSensorProtocol().isConnected() {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    configuration!.getSensorProtocol().connect()
                });
            }
        
        // different start configurations for different Environment modes
            if NSUserDefaults.standardUserDefaults().stringForKey(settings_env_conf) == settings_integrated_conf {
                
                self.btnStartGame.hidden            = true
                self.txtVUsername.hidden            = true
                self.lblWaitingforUser.hidden       = true
            
                self.lblWaitingforUser.hidden       = false
                self.lblWaitingforUser.text         = "Waiting for User ..."
            
                timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("checkUserAndSensortag"), userInfo: nil, repeats: true)
            
            } else if   NSUserDefaults.standardUserDefaults().stringForKey(settings_env_conf) == settings_kura_conf ||
                        NSUserDefaults.standardUserDefaults().stringForKey(settings_env_conf) == settings_test_conf ||
                        NSUserDefaults.standardUserDefaults().stringForKey(settings_env_conf) == settings_standalone_conf {
            
                self.btnStartGame.hidden            = false
                self.btnStartGame.enabled           = true
                self.lblWaitingforUser.hidden       = true
                self.playerNameText.text            = "Enter Username : "
                            
                timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("checkStatuses"), userInfo: nil, repeats: true)
            }
        
        // screen background
            let url = NSBundle.mainBundle().URLForResource("disco-anim", withExtension: "gif");
            let gif = UIImage.animatedImageWithAnimatedGIFURL(url)
        
            let screenSize              = UIScreen.mainScreen().bounds
            discoBall.image             = gif
            discoBall.frame             = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
            discoBall.contentMode       = UIViewContentMode.ScaleAspectFill

            self.view.addSubview(discoBall)
            self.view.sendSubviewToBack(discoBall)
            self.view.backgroundColor   = UIColor.brownColor()
        
            super.viewDidLoad()
        
        // function to hide keyboard after pressed 'return'
            self.txtVUsername.delegate  = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Integrated Mode
    func checkUserAndSensortag(){

        // get and initalize user
        configuration!.getUserProtocol().getUser()
        
        if  NSUserDefaults.standardUserDefaults().stringForKey(settings_env_conf) == settings_kura_conf ||
            NSUserDefaults.standardUserDefaults().stringForKey(settings_env_conf) == settings_test_conf ||
            NSUserDefaults.standardUserDefaults().stringForKey(settings_env_conf) == settings_standalone_conf {
                user.nickname = self.txtVUsername.text
        }
        
        if (user.running) {
            self.IVPlayerReceived.image         = UIImage(named: startButton)
            
            if (!configuration!.getSensorProtocol().isConnected()) {
                configuration!.getSensorProtocol().connect(startGame())
            } else {
                startGame()
            }
        } else {
            self.IVPlayerReceived.image         = UIImage(named: stopButton)
        }
    }
    
    // Kura and Test Mode
    func checkStatuses(){
        if configuration!.getSensorProtocol().sensorLeftStatus() {
            self.IVSensorLeftFound.image          = UIImage(named: startButton)
        }
        if configuration!.getSensorProtocol().sensorRightStatus() {
            self.IVSensorRightFound.image         = UIImage(named: startButton)
        }
    }
    
    //Method to dismiss keyboard on return key press
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Method to dismiss keyboard by touching to anywhere on the screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

