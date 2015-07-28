//
//  Hero.swift
//  BounceBack
//
//  Created by Zachary Espiritu on 7/27/15.
//  Copyright (c) 2015 Zachary Espiritu. All rights reserved.
//

import Foundation

class Hero: CCSprite {
    
    var currentSide: Side = .Left
    
    func switchSides() {
        if currentSide == .Left {
            self.animationManager.runAnimationsForSequenceNamed("LeftToRight")
        }
        else if currentSide == .Right {
            self.animationManager.runAnimationsForSequenceNamed("RightToLeft")
        }
    }
}