//
//  Move.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 4/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class Move {

    var name    : String
    var path    : String
    var tr      : Double
    var tl      : Double
    var br      : Double
    var bl      : Double
    
    init (name: String, path: String, tr: Double, tl: Double, br: Double, bl: Double) {
        self.name   = name
        self.path   = path
        self.tr     = tr
        self.tl     = tl
        self.br     = br
        self.bl     = bl
    }
}