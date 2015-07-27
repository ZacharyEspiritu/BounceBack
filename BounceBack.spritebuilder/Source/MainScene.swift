//
//  MainScene.swift
//  BounceBack
//
//  Created by Zachary Espiritu on 7/26/15.
//  Copyright (c) 2015 Zachary Espiritu. All rights reserved.
//

import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    weak var hero: Hero!
    
    weak var gameplayArea: CCNode!
    weak var gamePhysicsNode: CCPhysicsNode!
    
    var lastFourSides: [Side] = [.None, .None, .None, .None]
    
    var spikeArray: [Spike] = []
    
    func didLoadFromCCB() {
        
        gamePhysicsNode.collisionDelegate = self
        
        for index in 0..<21 {
            
            // Load a new piece from Piece.ccb and cast it as part of the piece class
            var spike = CCBReader.load("Spike") as! Spike
            
            // Randomizes the current piece's obstacle side and updates pieceLastSide since .setObstacle returns the chosen side.
            lastFourSides.append(spike.setSide(lastFourSides: lastFourSides))
            lastFourSides.removeAtIndex(0)
            
            // Set the position of the new piece to the just above the last piece
            var spikeHeight = spike.contentSizeInPoints.height * CGFloat(index)
            spike.position = CGPoint(x: gameplayArea.contentSizeInPoints.width / 2, y: spikeHeight)
            
            // Add the piece as a child of the piecesNode
            gamePhysicsNode.addChild(spike)
            
            // Append the piece to the end of the pieces array
            spikeArray.append(spike)
            
        }
        
        gamePhysicsNode.debugDraw = true
        
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
        
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        hero.switchSides()
        
        if hero.currentSide == .Left {
            gamePhysicsNode.gravity = CGPoint(x: 1500, y: 0)
            hero.physicsBody.velocity = CGPoint(x: 500, y: 0)
            hero.currentSide = .Right
        }
        else {
            gamePhysicsNode.gravity = CGPoint(x: -1500, y: 0)
            
            hero.physicsBody.velocity = CGPoint(x: -500, y: 0)
            hero.currentSide = .Left
        }
                
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, spike: CCNode!) -> Bool {
     
        println("spike")
        return true
        
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, leftWall: CCNodeGradient!) -> Bool {
        
        println("left")
        hero.animationManager.runAnimationsForSequenceNamed("LeftWallSlide")
        
        return true
        
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, rightWall: CCNodeGradient!) -> Bool {
        
        println("right")
        hero.animationManager.runAnimationsForSequenceNamed("RightWallSlide")
        
        return true
        
    }

}
