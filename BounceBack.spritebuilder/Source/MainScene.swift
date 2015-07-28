//
//  MainScene.swift
//  BounceBack
//
//  Created by Zachary Espiritu on 7/26/15.
//  Copyright (c) 2015 Zachary Espiritu. All rights reserved.
//

import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    var fallSpeed: CGFloat = 100
    
    // MARK: Variables
    
    weak var hero: Hero!
    
    weak var gameplayArea: CCNode!
    weak var gamePhysicsNode: CCPhysicsNode!
    
    weak var leftWall1, leftWall2, rightWall1, rightWall2: CCNode!
    var leftWallArray:  [CCNode] = []
    var rightWallArray: [CCNode] = []
    
    var lastFourSides: [Side] = [.None, .None, .None, .None]
    var spikeArray: [Spike] = []
    
    
    // MARK: Functions
    
    func didLoadFromCCB() {
        gamePhysicsNode.collisionDelegate = self
        
        for index in 0..<21 {
            var spike = CCBReader.load("Spike") as! Spike
            
            lastFourSides.append(spike.setSide(lastFourSides: lastFourSides))
            lastFourSides.removeAtIndex(0)
            
            var spikeHeight = spike.contentSizeInPoints.height * CGFloat(index)
            spike.position = CGPoint(x: gameplayArea.contentSizeInPoints.width / 2, y: spikeHeight)
            
            gamePhysicsNode.addChild(spike)
            spikeArray.append(spike)
        }
        
        leftWallArray.append(leftWall1)
        leftWallArray.append(leftWall2)
        rightWallArray.append(rightWall1)
        rightWallArray.append(rightWall2)
        
        gamePhysicsNode.debugDraw = true
        
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
    }
    
    override func update(delta: CCTime) {
        hero.position = CGPoint(x: hero.position.x, y: hero.position.y - (fallSpeed * CGFloat(delta)))
        gamePhysicsNode.position = CGPoint(x: gamePhysicsNode.position.x, y: gamePhysicsNode.position.y + (fallSpeed * CGFloat(delta)))
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        hero.switchSides()
        
        if hero.currentSide == .Left {
            gamePhysicsNode.gravity = CGPoint(x: 1500, y: 0)
            hero.physicsBody.velocity = CGPoint(x: 200, y: 0)
            hero.currentSide = .Right
        }
        else {
            gamePhysicsNode.gravity = CGPoint(x: -1500, y: 0)
            
            hero.physicsBody.velocity = CGPoint(x: -200, y: 0)
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
