//
//  ViewController.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 2/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import UIKit
import CoreData
import CoreBluetooth

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var playerNameText   : UITextField!
    @IBOutlet weak var playButton       : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        playButton.enabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func start(sender: UIButton) {

        IoTFeverGameService.start(playerNameText.text)
    
    }
    
}

