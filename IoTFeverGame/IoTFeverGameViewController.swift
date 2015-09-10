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

class IoTFeverGameViewController: UIViewController, IOTFeverDataAware, GameSubscribe {
    
    // MARK: UI Properties
    @IBOutlet weak var try1Image            : UIImageView!
    @IBOutlet weak var try2Image            : UIImageView!
    @IBOutlet weak var try3Image            : UIImageView!
    
    @IBOutlet weak var imageView            : UIImageView!
    
    @IBOutlet weak var timeLabel            : UILabel!
    @IBOutlet weak var timeCountLabel       : UILabel!
    
    @IBOutlet weak var levelLabel           : UILabel!
    @IBOutlet weak var levelAmountLabel     : UILabel!
    
    var currentGame                         : IoTFeverGame!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Subscriber
        currentGame = IoTFeverGame.start("Andreas", vc: self)
        sensorDelegate.subscribe(self)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Protocol IOTFeverDataAware
    func onDataIncoming(data: [Double]) {
        // wenn Game nicht null - an game liefern 
        
        
        // set Image
        // self.imageView.image = UIImage(named: currentGame.runningLevel.getNextRandomMove().path)

        // validate Move
        // currentGame.isAHit(data)
        
        // IoTFeverGame.current().setMove(data);
        // int hits = IoTFeverGame.current().getTotalHits();
        
    }
    
    // Protocol GameSubscribe
    func ended(){
        
    }
    
    func isAhit(hit: Bool) {
        
        if hit {
            // View - Pop Up - Green
        }
        else {
            // View - Pop Up - Red
        }
    }
    
    func setMove(move: Move) {
        self.imageView.image = UIImage(named: move.path)
    }
    
    func setCountdown(countdown: Int) {
        self.timeCountLabel.text = String(countdown)
    }
}
