//
//  ViewController.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 2/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import UIKit

var gameEnvironment : GameEnvironment?

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var playerNameText   : UILabel!
    
    var discoBall : UIImageView = UIImageView()
    
    func startGame(e : GameEnvironment) {
        gameEnvironment = e
        self.performSegueWithIdentifier("countdownIdentifier", sender: self)

    }
    
    override func viewDidLoad() {
        self.playerNameText.text = "Waiting for User ..."
    
        configuration!.canStartGame(startGame)
        
        let url = NSBundle.mainBundle().URLForResource("disco-anim", withExtension: "gif");
        let gif = UIImage.animatedImageWithAnimatedGIFURL(url)
        
        let screenSize = UIScreen.mainScreen().bounds
        discoBall.image = gif
        discoBall.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        discoBall.contentMode = UIViewContentMode.ScaleAspectFill

        self.view.addSubview(discoBall)
        self.view.sendSubviewToBack(discoBall)
        self.view.backgroundColor = UIColor.brownColor()
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

