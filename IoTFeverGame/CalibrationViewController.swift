//
//  SensorTagInitializationViewController.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 9/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import UIKit
import CoreBluetooth

class SensorTagInitializationViewController: UIViewController  {

    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startButton.enabled = false
        self.activityLoader.startAnimating()
        self.activityLoader.stopAnimating()
        self.startButton.enabled = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
