//
//  GameSubscribe.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 10/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

protocol GameSubscribe {
    func moveChanged(move: Move)
    func levelChanged(level: Level)
    func leftOverTime(countdown: Int)
    func ended()
}