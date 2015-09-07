//
//  IoTFeverGameViewController.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 3/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import UIKit

class IoTFeverGameViewController: UIViewController {

    // MARK: UI Properties
    @IBOutlet weak var timeHeadLabel: UILabel!
    @IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet weak var levelHeadLabel: UILabel!
    @IBOutlet weak var levelCountLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var level: Level
    var intervalCountdown: Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        level = LevelService.nextLevel()
        intervalCountdown = LevelService.nextLevel().duration
        
        var intervalCounter: Double = 1.0
        var intervalImage: Double   = 1.0
        
        // Change Counter
        var timerCountdown = NSTimer.scheduledTimerWithTimeInterval(intervalCounter, target: self, selector: Selector("updateCountdown:"), userInfo: nil, repeats: true)
        
        // Change Image
        var timerImage = NSTimer.scheduledTimerWithTimeInterval(intervalImage, target: self, selector: Selector("updateImage:"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Change Counter
    func updateCountdown(timer: NSTimer) {
        if(intervalCountdown >= 0) {
            timeCountLabel.text = String(intervalCountdown--)
        } else {
            timer.invalidate()
        }
    }
    
    // Change Image
    func updateImage(timer: NSTimer) {
        if (intervalCountdown > 0) {
            timer.fireDate = timer.fireDate.dateByAddingTimeInterval(Double(arc4random_uniform(3) + 1))
            imageView.image = UIImage(named: LevelService.getNextRandomMove().path)
        } else {
            timer.invalidate()

            var alert = UIAlertController(title: "Success", message: "Congratulation - You succeed the next Level!", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Next", style: UIAlertActionStyle.Default, handler: next))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func next(alert: UIAlertAction!) {
        
    }
    
    func cancel(alert: UIAlertAction!) {
        println("cancel")
    }
    
    func updateLevel() {
        if(intervalCountdown >= 0) {
            timeCountLabel.text = String(intervalCountdown--)
        }
    }
}
