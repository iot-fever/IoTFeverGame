//
//  CountdownViewController.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 15/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import UIKit

class CountdownViewController: UIViewController {

    @IBOutlet weak var lblUsername  : UILabel!
    @IBOutlet weak var lblCountDown : UILabel!
    
    var count = 5
    var timer : NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblUsername.text = "Welcome \(gameEnvironment!.username)"
        self.lblCountDown.text = "6"
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update(){
        if(count>0){
            self.lblCountDown.text = String(count--)
        }
        else{
            timer.invalidate()
            self.performSegueWithIdentifier("startGameIdentifier", sender: self)
        }
    }
    
}
