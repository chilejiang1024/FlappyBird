//
//  GameScene.swift
//  FlappyBird
//
//  Created by JiangChile on 16/5/14.
//  Copyright (c) 2016年 JiangChile. All rights reserved.
//

import SpriteKit

enum layer: CGFloat {
    case background
    case forceground
    case gameRole
}

class GameScene: SKScene {
    
    let kGravity: CGFloat = -1300.0                 // 重力, 数值为负, 意思是每秒下降的像素
    let kUpSpeed: CGFloat = 500.0
    var birdSpeed: CGPoint = CGPoint.zero
    let worldNode = SKNode()
    var gameAreaStartPoint: CGFloat = 0
    var gameAreaHeight: CGFloat = 0
    let bird = SKSpriteNode(imageNamed: "bird0_0")
    var lastUpdateTime: NSTimeInterval = 0          // 上一次更新时间
    var dt: NSTimeInterval = 0                      // 每次update间隔时间
    
    // ----------------------------------------------------------
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        addChild(worldNode)
        setupBackground()
        setupForceground()
        setupBird()
    }
    
    // mark: 设置背景 func
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "bg_day")
        background.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        background.position = CGPoint(x: size.width/2, y: size.height)
        background.zPosition = layer.background.rawValue
        worldNode.addChild(background)
        
        gameAreaStartPoint = size.height - background.size.height
        gameAreaHeight = background.size.height
    }
    
    // mark: 设置前景 func
    func setupForceground() {
        let forceground = SKSpriteNode(imageNamed: "land")
        forceground.anchorPoint = CGPoint(x: 0, y: 1.0)
        forceground.position = CGPoint(x: 0, y: 112)
        forceground.zPosition = layer.forceground.rawValue
        worldNode.addChild(forceground)
    }
    
    // mark: 设置主角
    func setupBird() {
        bird.position = CGPoint(x: size.width * 0.2, y: gameAreaHeight * 0.4)
        bird.zPosition = layer.gameRole.rawValue
        worldNode.addChild(bird)
    }
    
    // ----------------------------------------------------------
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        birdFly()
    }
    
    func birdFly() {
        birdSpeed = CGPoint(x: 0, y: kUpSpeed)
    }
    // ----------------------------------------------------------
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        updateBirdStatus()
    }
    
    func updateBirdStatus() {
        let acceleration = CGPoint(x: 0, y: kGravity)
        birdSpeed = CGPoint(x: 0, y: birdSpeed.y + acceleration.y * CGFloat(dt))
        bird.position = CGPoint(x: bird.position.x, y: bird.position.y + birdSpeed.y * CGFloat(dt))
        
        // 检测是否碰撞到地面
        if bird.position.y - bird.size.height/2 < 112 {
            print("game over")
        }
    }
}
