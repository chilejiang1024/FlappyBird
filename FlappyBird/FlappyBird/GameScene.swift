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
    case pipe
    case forceground
    case gameRole
}

class GameScene: SKScene {
    
    let kNumOfBackground = 2
    let kSpeedOfBackground: CGFloat = -100.0        // 背景移动速度
    let kGravity: CGFloat = -1000.0                 // 重力, 数值为负, 意思是每秒下降的像素
    let kUpSpeed: CGFloat = 400.0
    let kMinPipeTimes:CGFloat = 0.1
    let kMaxPipeTimes:CGFloat = 0.6
    let kTimes: CGFloat = 3.0
    let kPipeFirstCreateTimeDelay: NSTimeInterval = 1.75
    let kPipeCreateTimeDelay: NSTimeInterval = 1.5
    
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
        createPipeByLoop()
    }
    
    // mark: 设置背景 func
    func setupBackground() {
        for i in 1...kNumOfBackground {
            let background = SKSpriteNode(imageNamed: "bg_day")
            background.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            background.position = CGPoint(x: size.width / 2 * CGFloat(i), y: size.height)
            background.zPosition = layer.background.rawValue
            background.name = "background"
            worldNode.addChild(background)
            
            gameAreaStartPoint = size.height - background.size.height
            gameAreaHeight = background.size.height
        }
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
    // mark: 游戏逻辑
    func createPipe(imageName imageName: String) -> SKSpriteNode {
        let pipe = SKSpriteNode(imageNamed: imageName)
        pipe.zPosition = layer.pipe.rawValue
        return pipe
    }
    
    func setupPipes() {
        let pipeDown = createPipe(imageName: "pipe_up")
        let x = size.width + pipeDown.size.width / 2
        let yMin = gameAreaStartPoint - pipeDown.size.height / 2 + gameAreaHeight * kMinPipeTimes
        let yMax = gameAreaStartPoint - pipeDown.size.height / 2 + gameAreaHeight * kMaxPipeTimes
        pipeDown.position = CGPoint(x: x, y: CGFloat(arc4random() % UInt32(yMax - yMin)) + yMin)
        worldNode.addChild(pipeDown)
        
        let pipeUp = createPipe(imageName: "pipe_down")
        pipeUp.position = CGPoint(x: x, y: pipeDown.position.y + pipeDown.size.height + bird.size.height * kTimes)
        worldNode.addChild(pipeUp)
        
        let xMove: CGFloat = -(size.width + pipeDown.size.width)
        let moveTime = xMove / kSpeedOfBackground
        let moveActionQueue = SKAction.sequence([
            SKAction.moveByX(xMove, y: 0, duration: NSTimeInterval(moveTime)),
            SKAction.removeFromParent()
        ])
        pipeDown.runAction(moveActionQueue)
        pipeUp.runAction(moveActionQueue)
    }
    
    func createPipeByLoop() {
        let firstDelay = SKAction.waitForDuration(kPipeFirstCreateTimeDelay)
        let createPipe = SKAction.runBlock { () -> Void in
            self.setupPipes()
        }
        let pipeCreateDelay = SKAction.waitForDuration(kPipeCreateTimeDelay)
        let pipeCreateQueue = SKAction.sequence([createPipe, pipeCreateDelay])
        let createForever = SKAction.repeatActionForever(pipeCreateQueue)
        let actionQueue = SKAction.sequence([firstDelay, createForever])
        runAction(actionQueue)
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
        updateBackground()
    }
    
    func updateBirdStatus() {
        let acceleration = CGPoint(x: 0, y: kGravity)
        birdSpeed = CGPoint(x: 0, y: birdSpeed.y + acceleration.y * CGFloat(dt))
        bird.position = CGPoint(x: bird.position.x, y: bird.position.y + birdSpeed.y * CGFloat(dt))
        
        // 检测是否碰撞到地面
        if bird.position.y - bird.size.height/2 < 112 {
            // print("game over")
        }
    }
    
    func updateBackground() {
        worldNode.enumerateChildNodesWithName("background") { (node, _) -> Void in
            if let background = node as? SKSpriteNode {
                let speedOfBackgrond = CGPoint(x: self.kSpeedOfBackground, y: 0)
                background.position.x += speedOfBackgrond.x * CGFloat(self.dt)
                
                if background.position.x < 0 {
                    background.position.x = background.size.width / 2 * CGFloat(self.kNumOfBackground)
                }
            }
        }
    }
    
}
