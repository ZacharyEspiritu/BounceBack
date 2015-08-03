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
    
    func setSide(#lastFiveSides: [Side]) -> Side {
        
        if lastFiveSides[4] == .Left {
            if lastFiveSides[3] == .Left && lastFiveSides[2] == .Left && lastFiveSides[1] == .Left && lastFiveSides[0] == .Left {
                let rand = CCRANDOM_0_1()
                
                if rand < 0.40 {
                    side = .Left
                }
                else if rand < 0.80 {
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
        else if lastFiveSides[4] == .Right {
            if lastFiveSides[3] == .Right && lastFiveSides[2] == .Right && lastFiveSides[1] == .Right && lastFiveSides[0] == .Right {
                let rand = CCRANDOM_0_1()
                
                if rand < 0.40 {
                    side = .Right
                }
                else if rand < 0.8 {
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
        else if lastFiveSides[4] == .Both {
            if lastFiveSides[3] == .Right {
                side = .Right
            }
            else if lastFiveSides[3] == .Left {
                side = .Left
            }
            else {
                side = .None
            }
        }
        else if lastFiveSides[4] == .None {
            if lastFiveSides[3] == .Right {
                side = .Left
            }
            else {
                side = .Right
            }
        }
        
        return side
    }
}
