//
//  GameViewController.swift
//  FlappyBird
//
//  Created by JiangChile on 16/5/14.
//  Copyright (c) 2016年 JiangChile. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let skView = self.view as? SKView {
            if skView.scene == nil {
                // 创建场景
                let sence = GameScene()
                let aspectRatio = skView.bounds.size.height / skView.bounds.size.width
                sence.size = CGSize(width: 288, height: 288 * aspectRatio)
                sence.scaleMode = .AspectFill
                
                skView.showsFPS = true
                skView.showsNodeCount = true
                skView.showsPhysics = true
                skView.ignoresSiblingOrder = true
                
                skView.presentScene(sence)
            }
        }
    }
    
    // 状态栏是否隐藏
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}