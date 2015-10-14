//
//  GameEnd.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 15/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import UIKit

class EndViewController : UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var lblResult                : UILabel!
    @IBOutlet weak var lblScore                 : UILabel!
    @IBOutlet weak var lblScoreResult           : UILabel!
    @IBOutlet weak var tblVhighScoreRanking     : UITableView!
    @IBOutlet weak var btnNewGame: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // the maximum score dependence on the hits and the duration of each level
        if currentGame.player.score == 23 {
            self.lblResult.text = "You are a Dance God!"
        } else {
            self.lblResult.text = "Game Over!"
        }
        
        if NSUserDefaults.standardUserDefaults().stringForKey(settings_env_conf) == "integrated_conf" {
            self.btnNewGame.hidden = true
            NSTimer.scheduledTimerWithTimeInterval(8.0, target: self, selector: Selector("restartGame:"), userInfo: nil, repeats: false)
        } else if NSUserDefaults.standardUserDefaults().stringForKey(settings_env_conf) == "kura_conf" ||
            NSUserDefaults.standardUserDefaults().stringForKey(settings_env_conf) == "test_conf" {
            self.btnNewGame.hidden = false
        }
        
        configuration!.getRankingService().publish(currentGame.player)
        
        // 25 is the current game duration
        self.lblScoreResult.text = String(currentGame.player.score) + "/ 25"
        
        self.tblVhighScoreRanking.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblVhighScoreRanking.delegate = self
        tblVhighScoreRanking.dataSource = self
    
        gameStarted = false
    }
    
    @IBAction func newGame(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.performSegueWithIdentifier("restartGameIdentifier", sender: self)
        });
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ScoreRanking.current.players!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tblVhighScoreRanking.dequeueReusableCellWithIdentifier("cell", forIndexPath:indexPath) as UITableViewCell
        
        cell.textLabel!.text = String(indexPath.row+1) + ". " + ScoreRanking.current.players![indexPath.row].name
       
        
        return cell
    }
    
    func dismiss() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in})
    }
}
