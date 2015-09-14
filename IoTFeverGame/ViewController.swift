//
//  ViewController.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 2/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var playerNameText   : UITextField!
    @IBOutlet weak var playButton       : UIButton!
    var discoBall : UIImageView = UIImageView()
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        
        playButton.enabled = true
        
        let url = NSBundle.mainBundle().URLForResource("disco-anim", withExtension: "gif");
        let gif = UIImage.animatedImageWithAnimatedGIFURL(url)
        
        let screenSize = UIScreen.mainScreen().bounds
        discoBall.image = gif
        discoBall.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)

        self.view.addSubview(discoBall)
        self.view.sendSubviewToBack(discoBall)
        self.view.backgroundColor = UIColor.brownColor()
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func start(sender: UIButton) {
        // EntityManager.sharedInstance.add(IoTFeverGame(username: playerNameText.text))

    }
    
}

