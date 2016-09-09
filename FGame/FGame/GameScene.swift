//
//  GameScene.swift
//  FGame
//
//  Created by Admin on 8/29/16.
//  Copyright (c) 2016 Techkids. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var plane:SKSpriteNode!
    var bullets : [SKSpriteNode] = []
    var enemies : [SKSpriteNode] = []
    var lastUpdateTime : NSTimeInterval = -1
    
    var countBullet = 0
    var countEnemy = 0
    
    var bulletIntervalCount = 0
    var enemyIntervalCount = 0
    override func didMoveToView(view: SKView) {
        
        print("didMovetoView")
        addBackground()
        addPlane()
        
        
    }
    
    func addBackground(){
        //1
        
        let background = SKSpriteNode(imageNamed: "background.png")
        
        //2
        background.anchorPoint = CGPointZero
        background.position = CGPointZero
        
        //3
        addChild(background)
    }
    
    func addBullet() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.position = CGPoint(x: plane.position.x, y: plane.position.y + plane.frame.size.height / 2 + bullet.frame.size.height / 2)
        
        let bulletFly = SKAction.moveByX(0, y: 50, duration: 0.1)
        
        bullet.runAction(SKAction.repeatActionForever( bulletFly))
        
        addChild(bullet)
        bullets.append(bullet)
    }
    func addPlane()  {
        
        plane = SKSpriteNode(imageNamed: "plane3.png")
        plane.position = CGPoint(x: self.frame.size.width/2, y:self.frame.size.height/2)
        
        let shot = SKAction.runBlock {
            self.addBullet()
        }
        
        let shotPeriod = SKAction.sequence([shot, SKAction.waitForDuration(0.2)])
        
        let shotForever = SKAction.repeatActionForever(shotPeriod)
        
        plane.runAction(shotForever)
        addChild(plane)
    }
    
    func addEnemy() {
        let enemy = SKSpriteNode(imageNamed: "enemy_plane_white_1.png")
        
        let diceRoll = Int(arc4random_uniform(UInt32 (self.frame.size.width)))
        
        enemy.position = CGPoint(x: CGFloat (diceRoll) , y: self.frame.size.height)
        
        let enemyFly = SKAction.moveByX(0, y: -30, duration: 0.1)
        
        enemy.runAction(SKAction.repeatActionForever(enemyFly))
        addChild(enemy)
        enemies.append(enemy)
        
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        print("touchesBegan")
        //        if let touch = touches.first{
        //            let touchPosition = touch.locationInNode(self)
        //            plane.position = CGPoint(x: touchPosition.x, y: touchPosition.y)
        //        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesMoved")
        print("touches count:\(touches.count)")
        if let touch = touches.first{
            //1
            let currentTouch = touch.locationInNode(self)
            let previousTouch = touch.previousLocationInNode(self)
            
            //2: Calculate movement vector
            //3
            
            var planePosition = currentTouch.subtract(previousTouch).add(plane.position)
            
            if planePosition.x > self.size.width {
                planePosition.x = self.size.width
            }
            if planePosition.x < 0 {
                planePosition.x = 0
            }
            if planePosition.y > self.size.height {
                planePosition.y = self.size.height
            }
            if planePosition.y < 0 {
                planePosition.y = 0
            }
            plane.position = planePosition
            
        }
        
        //        print(touches.first)
        
    }
    
    func addCGPoint(p1 : CGPoint, p2 : CGPoint) -> CGPoint {
        let dx = p1.x - p2.x
        let dy = p1.y - p2.y
        
        return CGPoint(x: dx, y: dy)
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        print("currentTime: \(currentTime)")
        
        if lastUpdateTime == -1 {
            lastUpdateTime = currentTime
        } else {
            let deltaTime = currentTime - lastUpdateTime
            let deltaTimeMiliseconds = deltaTime * 1000
            
            if deltaTimeMiliseconds > 10 {
                lastUpdateTime = currentTime
                countEnemy += 1
                if(countEnemy == 10){
                    addEnemy()
                    countEnemy = 0
                }
            }
        }
        //
        //        for bullet in bullets {
        //            bullet.position.y += 15
        //        }
        
        
        //        for enemy in enemies {
        //            enemy.position.y -= 4
        //        }
        
        for (bulletIndex, bullet) in bullets.enumerate() {
            for (enemyIndex, enemy) in enemies.enumerate() {
                let bulletFrame = bullet.frame
                let enemyFrame = enemy.frame
                if(CGRectIntersectsRect(bulletFrame, enemyFrame)){
                    bullets.removeAtIndex(bulletIndex)
                    enemies.removeAtIndex(enemyIndex)
                    bullet.removeFromParent()
                    enemy.removeFromParent()
                }
            }
        }
        
    }
}
