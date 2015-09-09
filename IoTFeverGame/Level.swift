//
//  Level.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class Level {

    var name: Int
    var duration: Int
    var moves: [Move]

    init (name: Int, duration: Int) {
        
        self.name = 1
        self.duration = duration        
        self.moves = [Move]()
        
        moves.append(Move(name: "TR", path: "TR.jpg", tr: 1, tl: 0, br: 0, bl: 0))
        moves.append(Move(name: "TL", path: "TL.jpg", tr: 0, tl: 1, br: 0, bl: 0))
        moves.append(Move(name: "BR", path: "BR.jpg", tr: 0, tl: 0, br: 1, bl: 0))
        moves.append(Move(name: "BL", path: "BL.jpg", tr: 0, tl: 0, br: 0, bl: 1))
        
        moves.append(Move(name: "TL_TR", path: "TL_TR.jpg", tr: 1, tl: 1, br: 0, bl: 0))
        moves.append(Move(name: "TL_BR", path: "TL_BR.jpg", tr: 0, tl: 1, br: 1, bl: 0))
        moves.append(Move(name: "BL_BR", path: "BL_BR.jpg", tr: 0, tl: 1, br: 1, bl: 1))
        moves.append(Move(name: "TR_BL", path: "TR_BL.jpg", tr: 1, tl: 0, br: 0, bl: 1))
    }
}