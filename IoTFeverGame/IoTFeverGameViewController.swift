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

class IoTFeverGameViewController: UIViewController{
    
    // MARK: UI Properties
    @IBOutlet weak var try1Image: UIImageView!
    @IBOutlet weak var try2Image: UIImageView!
    @IBOutlet weak var try3Image: UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeCountLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelAmountLabel: UILabel!
    
    var countdown           : Int       = 90
    var intervalCountdown   : Double    = 1.0
    var intervalImage       : Double    = 3.0
    var duration            : UInt32    = UInt32(EntityManager.sharedInstance.get().runningLevel.duration)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change Counter
        self.timeCountLabel.text    = String(90)
        var timerCountdown = NSTimer.scheduledTimerWithTimeInterval(intervalCountdown, target: self, selector: Selector("updateCountdown:"), userInfo: nil, repeats: true)
        
        // Change Image
        self.timeCountLabel.text   = String(EntityManager.sharedInstance.get().runningLevel.name)
        var timerImage = NSTimer.scheduledTimerWithTimeInterval(intervalImage, target: self, selector: Selector("updateImage:"), userInfo: nil, repeats: true)
        
        // let movementData = SensorReader.getMovementData(characteristic.value)
        // let accelData = SensorReader.getAccelerometerData(movementData)
        
        // move = accelData[0]
        
        // self.timeLabel.text = String(stringInterpolationSegment: move)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Change Counter
    func updateCountdown(timer: NSTimer) {
        if(countdown >= 0) {
            self.timeCountLabel.text = String(countdown--)
        } else {
            timer.invalidate()
        }
    }
    
    // Change Image
    func updateImage(timer: NSTimer) {
        
        switch countdown {
        
        //Level1
        case 60...90:
            self.imageView.image = UIImage(named: LevelService.getNextRandomMove().path)
            //Sensortag - Validation
            
            timer.fireDate = timer.fireDate.dateByAddingTimeInterval(3)
            self.levelAmountLabel.text = String(1)
        
        //Level2
        case 30...60:
            self.imageView.image = UIImage(named: LevelService.getNextRandomMove().path)
            //Sensortag - Validation
            
            timer.fireDate = timer.fireDate.dateByAddingTimeInterval(2)
            self.levelAmountLabel.text = String(2)
        
        //Level3
        case 1...30:
            self.imageView.image = UIImage(named: LevelService.getNextRandomMove().path)
            //Sensortag - Validation
            
            timer.fireDate = timer.fireDate.dateByAddingTimeInterval(1)
            self.levelAmountLabel.text = String(3)
        
        //Finish
        case 0:
            timer.invalidate()
            
            var alert = UIAlertController(title: "Success", message: "Congratulation - You completed all Moves!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Next", style: UIAlertActionStyle.Default, handler: next))
            
            self.presentViewController(alert, animated: true, completion: nil)
        
        default:
            println("default")
        }
    }
    
    func next(alert: UIAlertAction!) {
        println("Success")
    }
    
    func cancel(alert: UIAlertAction!) {
        println("cancel")
    }
}
