//
//  GameEnd.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 15/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import UIKit

class GameEndViewController : UIViewController {

    
    @IBOutlet weak var lblResult        : UILabel!
    @IBOutlet weak var lblScore         : UILabel!
    @IBOutlet weak var lblScoreResult   : UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameEnvironment!.sensorService.disconnect()
        
        if currentGame.player.score == 100 {
            self.lblResult.text = "You Won!!"
        } else {
            self.lblResult.text = "Game Over!!"
        }
        
        self.lblScoreResult.text = String(currentGame.player.score)
        
        // TODO replace with Publisher (Protocol)
        
        gameEnvironment!.rankingService.publish(currentGame.player)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
