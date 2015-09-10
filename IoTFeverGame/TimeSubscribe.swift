//
//  TimeSubscriber.swift
//  IoTFeverGame
//
//  Created by Foitzik Andreas on 10/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

protocol TimeSubscribe {
    func setMove(move: Move)
    func setCountdown(countdown: Int)
}