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

class VisualizerView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        var scale = 0.5;
        emitterLayer.setValue(scale,  forKeyPath: "emitterCells.cell.emitterCells.childCell.scale")
    }
    
    override init (frame : CGRect) {
        let screenSize = UIScreen.mainScreen().bounds
        super.init(frame : CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        
        var width = screenSize.width;
        var height = screenSize.height;
        
        emitterLayer.emitterPosition = CGPointMake(width/2, height/2);
        emitterLayer.emitterSize = CGSizeMake(width-80, 60);
        emitterLayer.emitterShape = kCAEmitterLayerRectangle;
        emitterLayer.renderMode = kCAEmitterLayerAdditive;
        
        var cell = CAEmitterCell();
        cell.name = "cell";
        cell.contents = UIImage(named: "particleTexture.png")?.CGImage
        
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
        
        self.layer.addSublayer(emitterLayer)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}
