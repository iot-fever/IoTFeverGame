//
//  VisualizerView.swift
//  IoTFeverGame
//
//  Created by Zubair Hamed on 14/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import UIKit
import AVFoundation

let emitterLayer : CAEmitterLayer = CAEmitterLayer()

var audioPlayer : AVAudioPlayer!

class VisualizerView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {

    }

    let minDecibels = -200.0
    let tableSize = 800
    let root = 1.5
    
    var meterTable = [Float](count: 800, repeatedValue: 0.0)
    var mMinDecibels : Float!
    var mDecibelResolution: Float!
    var mScaleFactor: Float!
    
    func meterTableValueAt(inDecibels : Float) -> Float {
        if inDecibels < Float(minDecibels) {
            return 0
        }
        
        if inDecibels >= 0 {
            return 1
        }
        
        var index : Int = Int(inDecibels * mScaleFactor)
        
        return meterTable[index]
    }
    
    func dbToAmp(inDb: Float) -> Float {
        return pow(10, 0.05 * inDb)
    }
    
    override init (frame : CGRect) {
        let screenSize = UIScreen.mainScreen().bounds
        super.init(frame : CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        
        // Init Meter Table and Visualizer values
        mMinDecibels = Float(minDecibels)
        mDecibelResolution = mMinDecibels / Float((tableSize - 1))
        mScaleFactor = 1 / mDecibelResolution
        
        var minAmp : Float = self.dbToAmp(Float(minDecibels))
        var ampRange = 1 - minAmp
        var invAmpRange = 1 / ampRange
        
        var rroot = 1 / root
        for (var i=0; i < tableSize; i++) {
            var decibels = Float(i) * mDecibelResolution
            var amp = self.dbToAmp(decibels)
            var adjAmp = (amp - minAmp) * invAmpRange
            meterTable[i] = pow(Float(adjAmp), Float(rroot))
        }
        
        // Init Particle Layer
        var width = screenSize.width;
        var height = screenSize.height;
        
        emitterLayer.emitterPosition = CGPointMake(width/2, height/2);
        emitterLayer.emitterSize = CGSizeMake(width-80, 60);
        emitterLayer.emitterShape = kCAEmitterLayerRectangle;
        emitterLayer.renderMode = kCAEmitterLayerAdditive;
        
        var cell = CAEmitterCell();
        cell.name = "cell";
        cell.contents = UIImage(named: "particleTexture.png")?.CGImage
        
        var childCell = CAEmitterCell()
        childCell.name = "childCell"
        childCell.lifetime = 1.0 / 60.0;
        childCell.birthRate = 60.0;
        childCell.velocity = 0.0;
        childCell.contents = UIImage(named: "particleTexture.png")?.CGImage

        cell.emitterCells = [childCell];
        
        cell.color = UIColor(red: 1.0, green: 0.53, blue: 0.0, alpha: 0.8).CGColor
        cell.redRange = 0.46;
        cell.greenRange = 0.49;
        cell.blueRange = 0.67;
        cell.alphaRange = 0.55;
        
        cell.redSpeed = 0.11;
        cell.greenSpeed = 0.07;
        cell.blueSpeed = -0.25;
        cell.alphaSpeed = 0.15;
        
        cell.scale = 0.5;
        cell.scaleRange = 0.5;
        
        cell.lifetime = 1.0;
        cell.lifetimeRange = 0.25;
        cell.birthRate = 80;
        
        cell.velocity = 100.0;
        cell.velocityRange = 300.0;
        cell.emissionRange = CGFloat(M_PI * 2);
        
        emitterLayer.emitterCells = [cell];
                
        var updater = CADisplayLink(target: self, selector: Selector("update"))
        updater.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        
        self.layer.addSublayer(emitterLayer)
        
        playAudio()
    }
    
    // Update Vizualiser Scale
    func update() {
        var scale : Float = 0.5;
        if audioPlayer.playing {
            audioPlayer.updateMeters()
            
            var power : Float = 0.0
            for (var i = 0; i < audioPlayer.numberOfChannels; i++) {
                power = power + audioPlayer.averagePowerForChannel(i)
            }
            power /= Float(audioPlayer.numberOfChannels)
            var level = self.meterTableValueAt(power)
            scale = level * 2;
        }
        
        emitterLayer.setValue(scale, forKeyPath: "emitterCells.cell.emitterCells.childCell.scale")
    }
    
    func playAudio() {
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docsDir = dirPaths[0]
        let soundFilePath = (docsDir as NSString).stringByAppendingPathComponent("disco.mp3")
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: soundFileURL, fileTypeHint:nil)
        } catch {
            //Handle the error
        }
        

        
        audioPlayer.numberOfLoops = -1
        
        audioPlayer.meteringEnabled = true
        
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func stopAudio(){
        audioPlayer.stop()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}

