//
//  GameEnd.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 15/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import UIKit

class EndViewController : UIViewController {

    
    @IBOutlet weak var lblResult                : UILabel!
    @IBOutlet weak var lblScore                 : UILabel!
    @IBOutlet weak var lblScoreResult           : UILabel!
    @IBOutlet weak var lblsensorRightFound      : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // the maximum score dependence on the hits and the duration of each level
        if currentGame.player.score == 23 {
            self.lblResult.text = "You are a Dance God!"
        } else {
            self.lblResult.text = "Game Over!"
        }
        
        // 25 is the current game duration
        self.lblScoreResult.text = String(currentGame.player.score) + "/ 25"
       
        gameStarted = false
        
        NSTimer.scheduledTimerWithTimeInterval(8.0, target: self, selector: Selector("restartGame:"), userInfo: nil, repeats: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func restartGame(timer: NSTimer){
        timer.invalidate()
        user = User(running: false)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.performSegueWithIdentifier("restartGameIdentifier", sender: self)
        });
    }
}
