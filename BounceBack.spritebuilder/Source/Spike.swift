//
//  Spike.swift
//  BounceBack
//
//  Created by Zachary Espiritu on 7/27/15.
//  Copyright (c) 2015 Zachary Espiritu. All rights reserved.
//

import Foundation

enum Side {
    case Left, Right, Both, None
}

class Spike: CCNode {
    
    weak var leftSpike: CCSprite!
    weak var rightSpike: CCSprite!
    
    var side: Side = .None {
        
        // Purpose of using didSet: it's called everytime the side variable is set, which automatically will trigger which side will be the correct one to display.
        didSet {
            
            leftSpike.visible = false
            rightSpike.visible = false
            
            rightSpike.position = CGPoint(x: -1, y: rightSpike.position.y)
            leftSpike.position = CGPoint(x: -1, y: leftSpike.position.y)
            
            if side == .Right {
                rightSpike.visible = true
                rightSpike.position = CGPoint(x: 0, y: rightSpike.position.y)
            }
            else if side == .Left {
                leftSpike.visible = true
                leftSpike.position = CGPoint(x: 0, y: leftSpike.position.y)
            }
            else if side == .Both {
                leftSpike.visible = true
                rightSpike.visible = true
                
                rightSpike.position = CGPoint(x: 0, y: rightSpike.position.y)
                leftSpike.position = CGPoint(x: 0, y: leftSpike.position.y)
            }
            
        }
        
    }
    
    func didLoadFromCCB() {
        leftSpike.physicsBody.sensor = true
        rightSpike.physicsBody.sensor = true
    }
    
    func setSide(#lastFourSides: [Side]) -> Side {
        
        if lastFourSides[3] == .Left {
            if lastFourSides[2] == .Left && lastFourSides[1] == .Left && lastFourSides[0] == .Left {
                let rand = CCRANDOM_0_1()
                
                if rand < 0.40 {
                    side = .Left
                }
                else if rand < 0.8 {
                    side = .Right
                }
                else if rand < 0.95 {
                    side = .Both
                }
                else {
                    side = .None
                }
            }
            else {
                side = .Left
            }
        }
        else if lastFourSides[3] == .Right {
            if lastFourSides[2] == .Right && lastFourSides[1] == .Right && lastFourSides[0] == .Right {
                let rand = CCRANDOM_0_1()
                
                if rand < 0.40 {
                    side = .Left
                }
                else if rand < 0.8 {
                    side = .Right
                }
                else if rand < 0.95 {
                    side = .Both
                }
                else {
                    side = .None
                }
            }
            else {
                side = .Right
            }
        }
        else {
            let rand = CCRANDOM_0_1()
            
            if rand < 0.45 {
                side = .Left
            }
            else if rand < 0.9 {
                side = .Right
            }
            else {
                side = .None
            }
        }
        
        return side
    }
}
