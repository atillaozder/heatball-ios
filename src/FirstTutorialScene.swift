//
//  FirstTutorialScene.swift
//  HeatBall
//
//  Created by Atilla Özder on 8.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

class FirstTutorialScene: TutorialScene {
    
    private var childNodes: [SKNode] = []
    
    override func didChangeSafeArea() {
        super.didChangeSafeArea()
        childNodes.forEach { $0.position.y -= safeAreaInsets.top }
    }
        
    override func setupScene() {
        super.setupScene()
        presentScore()
        presentHearts()
    }
    
    override func nextTapped() {
        super.nextTapped()
        let newScene = LastTutorialScene(size: frame.size)
        self.presentTutorial(newScene, delegate: sceneDelegate)
    }
    
    override func presentDescription() {
        let score = SKLabelNode.defaultLabel
        score.position = .init(
            x: frame.maxX - 80,
            y: frame.maxY - 112 - safeAreaInsets.top)
        score.text = "Score"
        
        let asset: Asset = userSettings.currentTheme == .dark ?
            .icWhiteArrow :
            .icBlackArrow
        
        let scoreArrow = asset.asNode
        scoreArrow.position = .init(
            x: frame.maxX - 64,
            y: frame.maxY - 64 - safeAreaInsets.top)
        scoreArrow.zRotation = CGFloat(145.toRadians)
        
        let heatLevel = SKLabelNode.defaultLabel
        heatLevel.position = .init(
            x: frame.minX + 80,
            y: frame.maxY - 112 - safeAreaInsets.top)
        heatLevel.text = "Moves"
        
        let heatArrow = asset.asNode
        heatArrow.position = .init(
            x: frame.minX + 64,
            y: frame.maxY - 64 - safeAreaInsets.top)
        heatArrow.zRotation = CGFloat(-145.toRadians)
        
        [score, scoreArrow, heatLevel, heatArrow].forEach { (node) in
            addChild(node)
            childNodes.append(node)
        }
    }
    
    private func presentScore() {
        let score = SKLabelNode.defaultLabel
        score.text = "0"
        score.position = CGPoint(
            x: frame.maxX - 32,
            y: frame.maxY - 32 - safeAreaInsets.top)
        self.addChild(score)
        childNodes.append(score)
    }
    
    private func presentHearts() {
        let posX = frame.minX + HeartNode.nodeSize.width + 16
        let posY = frame.maxY - HeartNode.nodeSize.height - 16 - safeAreaInsets.top
        
        for i in 0..<8 {
            let rodPosX = posX + ((HeartNode.nodeSize.width + 4) * CGFloat(i))
            let node = HeartNode(origin: .init(x: rodPosX, y: posY))
            self.addChild(node)
            childNodes.append(node)
        }
    }
}


