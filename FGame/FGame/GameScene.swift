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
    var lastUpdateTimeEnemy : NSTimeInterval = -1
    
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
        bullet.position = plane.position
        addChild(bullet)
        bullets.append(bullet)
    }
    func addPlane()  {
        
        plane = SKSpriteNode(imageNamed: "plane3.png")
        plane.position = CGPoint(x: self.frame.size.width/2, y:self.frame.size.height/2)
        addChild(plane)
    }
    
    func addEnemy() {
        let enemy = SKSpriteNode(imageNamed: "enemy_plane_white_1.png")
        
        enemy.position = CGPoint(x: self.frame.size.width  / 2, y: self.frame.size.height)
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
            
            if deltaTimeMiliseconds > 200 {
                lastUpdateTime = currentTime
                addBullet()
            }
        }
        
        for bullet in bullets {
            bullet.position.y += 15
        }
        
        if lastUpdateTimeEnemy == -1 {
            lastUpdateTimeEnemy = currentTime
        } else {
            let deltaTime = currentTime - lastUpdateTimeEnemy
            let deltaTimeMilisecondsEnemy = deltaTime * 1000
            
            if deltaTimeMilisecondsEnemy > 500 {
                lastUpdateTimeEnemy = currentTime
                addEnemy()
            }
        }
        
        for enemy in enemies {
            enemy.position.y -= 4
        }
        
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
