//
//  TwoStepMove.swift
//  IoTFeverGame
//
//  Created by Alexander Edelmann on 13/9/15.
//  Copyright (c) 2015 Foitzik Andreas. All rights reserved.
//

import Foundation

class TwoStepMove : Move {
    
    var firstMove : SingleMove?
    var secondMove : SingleMove?
    
    init(firstMove: SingleMove, secondMove: SingleMove) {
        self.firstMove = firstMove
        self.secondMove = secondMove
    }
    
    func isSuccessful() -> Bool {
         return firstMove!.isSuccessful() && secondMove!.isSuccessful()
    }
    
    func getImage() -> String {
        if (firstMove!.position == ArmPosition.Top && secondMove!.position == ArmPosition.Top) {
            return "TL_TR.jpg"
        } else if (firstMove!.position == ArmPosition.Top && secondMove!.position == ArmPosition.Bottom) {
            return "TL_BR.jpg"
        } else if (firstMove!.position == ArmPosition.Bottom && secondMove!.position == ArmPosition.Top) {
            return "BL_TR.jpg"
        } else {
            return "BL_BR.jpg"
        }
    }
    
    
}
