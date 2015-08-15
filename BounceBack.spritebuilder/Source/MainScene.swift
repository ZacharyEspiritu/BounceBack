//
//  MainScene.swift
//  BounceBack
//
//  Created by Zachary Espiritu on 7/26/15.
//  Copyright (c) 2015 Zachary Espiritu. All rights reserved.
//

import Foundation

enum GameState {
    case Initial, Playing, Paused, Menu, Gameover
}

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    // MARK: Constants
    
    let startingSpikePosition: CGFloat = -200
    let fallSpeed: CGFloat = 350
    let crossoverSpeed: CGFloat = 300
    
    
    // MARK: Variables
    
    var gameState: GameState = .Initial
    
    weak var hero: Hero!
    
    weak var gameplayArea: CCNode!
    weak var gamePhysicsNode: CCPhysicsNode!
    
    weak var leftWall1, leftWall2, rightWall1, rightWall2: CCNode!
    var leftWallArray:  [CCNode] = []
    var rightWallArray: [CCNode] = []
    
    var lastFiveSides: [Side] = [.None, .None, .None, .None, .None]
    var spikeArray: [Spike] = []
    
    var jumpsRemaining: Int = 2
    
    weak var scoreLabel: CCLabelTTF!
    var score: Double = 0 {
        didSet {
            let truncatedScore = Double(round(10 * score) / 10)
            scoreLabel.string = "\(truncatedScore) m"
        }
    }
    
    weak var titleScreen: CCNode!
    
    // MARK: Functions
    
    func didLoadFromCCB() {
        gamePhysicsNode.collisionDelegate = self
        
        for index in 0..<21 {
            spawnNewSpike()
        }
        
        leftWallArray.append(leftWall1)
        leftWallArray.append(leftWall2)
        rightWallArray.append(rightWall1)
        rightWallArray.append(rightWall2)
        
        //gamePhysicsNode.debugDraw = true
        
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
        
        gameState = .Initial
    }
    
    func spawnNewSpike() {
        var previousSpikePosition: CGFloat = startingSpikePosition
        if spikeArray.count > 0 {
            previousSpikePosition = spikeArray.last!.position.y
        }
        
        let spike = CCBReader.load("Spike") as! Spike
        
        lastFiveSides.append(spike.setSide(lastFiveSides: lastFiveSides))
        lastFiveSides.removeAtIndex(0)
        
        spike.position = CGPoint(x: gameplayArea.contentSizeInPoints.width / 2, y: previousSpikePosition - spike.contentSizeInPoints.height)
        
        gamePhysicsNode.addChild(spike)
        spikeArray.append(spike)
    }
    
    override func update(delta: CCTime) {
        
        if gameState == .Playing {
            
            score += delta * 5
            
            hero.position = CGPoint(x: hero.position.x, y: hero.position.y - (fallSpeed * CGFloat(delta)))
            gamePhysicsNode.position = CGPoint(x: gamePhysicsNode.position.x, y: gamePhysicsNode.position.y + (fallSpeed * CGFloat(delta)))
            
            for wall in leftWallArray {
                let wallPosition = convertToNodeSpace(gamePhysicsNode.convertToWorldSpace(wall.position))
                if wallPosition.y >= (wall.contentSize.height) {
                    wall.position = CGPoint(x: wall.position.x, y: wall.position.y - wall.contentSize.height * 2)
                }
            }

            for wall in rightWallArray {
                let wallPosition = convertToNodeSpace(gamePhysicsNode.convertToWorldSpace(wall.position))
                if wallPosition.y >= (wall.contentSize.height) {
                    wall.position = CGPoint(x: wall.position.x, y: wall.position.y - wall.contentSize.height * 2)
                }
                let scale = CCDirector.sharedDirector().contentScaleFactor
                gamePhysicsNode.position = ccp(round(gamePhysicsNode.position.x * scale) / scale, round(gamePhysicsNode.position.y * scale) / scale)
                hero.position = ccp(round(hero.position.x * scale) / scale, round(hero.position.y * scale) / scale)
            }
            
            for spike in spikeArray.reverse() {
                let spikePosition = convertToNodeSpace(gamePhysicsNode.convertToWorldSpace(spike.position))
                
                if spikePosition.y > gamePhysicsNode.contentSizeInPoints.height {
                    spike.removeFromParent()
                    spikeArray.removeAtIndex(find(spikeArray, spike)!)
                    
                    spawnNewSpike()
                }
            }
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        if gameState == .Playing {
            if jumpsRemaining > 0 {
                jumpsRemaining--
                hero.switchSides()
                
                if hero.currentSide == .Left {
                    gamePhysicsNode.gravity = CGPoint(x: 1500, y: 0)
                    hero.physicsBody.velocity = CGPoint(x: crossoverSpeed, y: 0)
                    hero.currentSide = .Right
                }
                else {
                    gamePhysicsNode.gravity = CGPoint(x: -1500, y: 0)
                    
                    hero.physicsBody.velocity = CGPoint(x: -crossoverSpeed, y: 0)
                    hero.currentSide = .Left
                }
                
            }
            else {
                println("nope")
            }
        }
        else if gameState == .Initial {
            titleScreen.runAction(CCActionFadeOut(duration: 1))
            delay(1) {
                gameState == .Playing
            }
        }
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, spike: CCNode!) -> Bool {
        if gameState != .Gameover {
            triggerGameover()
        }
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, leftWall: CCNodeGradient!) -> Bool {
        hero.animationManager.runAnimationsForSequenceNamed("LeftWallSlide")
        hero.physicsBody.velocity = CGPoint(x: 0, y: 0)
        
        if jumpsRemaining < 2 {
            let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.1, position: ccp(-5, 0)))
            let moveBack = CCActionEaseBounceOut(action: move.reverse())
            let shakeSequence = CCActionSequence(array: [move, moveBack])
            self.runAction(shakeSequence)
        }
        
        jumpsRemaining = 2
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, rightWall: CCNodeGradient!) -> Bool {
        hero.animationManager.runAnimationsForSequenceNamed("RightWallSlide")
        hero.physicsBody.velocity = CGPoint(x: 0, y: 0)
        
        if jumpsRemaining < 2 {
            let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.1, position: ccp(5, 0)))
            let moveBack = CCActionEaseBounceOut(action: move.reverse())
            let shakeSequence = CCActionSequence(array: [move, moveBack])
            self.runAction(shakeSequence)
        }
        
        jumpsRemaining = 2
        return true
    }
    
    func triggerGameover() {
        
        gameState = .Gameover
        
        if hero.currentSide == .Left {
            hero.runAction(CCActionRotateBy(duration: 0.3, angle: 50))
            hero.runAction(CCActionEaseBackIn(action: CCActionMoveBy(duration: 0.5, position: CGPoint(x: 100, y: -CCDirector.sharedDirector().viewSize().height))))
        }
        else {
            hero.runAction(CCActionRotateBy(duration: 0.3, angle: 50))
            hero.runAction(CCActionEaseBackIn(action: CCActionMoveBy(duration: 0.5, position: CGPoint(x: -100, y: -CCDirector.sharedDirector().viewSize().height))))
        }
        
        self.delay(0.07) {
            AudioServicesPlayAlertSound(UInt32(kSystemSoundID_Vibrate))
        }
        
        let randomPosition: CGFloat?
        if CCRANDOM_0_1() < 0.5 {
            randomPosition = -7
        }
        else {
            randomPosition = 7
        }
        
        let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(randomPosition!, randomPosition!)))
        let moveBack = CCActionEaseBounceOut(action: move.reverse())
        let shakeSequence = CCActionSequence(array: [move, moveBack])
        self.runAction(shakeSequence)
        
        delay(2) {
            var gameplayScene = CCBReader.load("MainScene") as! MainScene
            
            var scene = CCScene()
            scene.addChild(gameplayScene)
            
            CCDirector.sharedDirector().presentScene(scene)
        }
    }
    
    
    // MARK: Convenience Functions
    
    /**
    When called, delays the running of code included in the `closure` parameter.
    
    :param: delay  how long, in milliseconds, to wait until the program should run the code in the closure statement
    */
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
