//
//  TutorialScene.swift
//  HeatBall
//
//  Created by Atilla Özder on 6.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit
import GameplayKit

class TutorialScene: SKScene {
    
    weak var gameDelegate: GameSceneDelegate?
    
    lazy var ball: SKShapeNode = {
        let ball = SKShapeNode(circleOfRadius: 25 / 2)
        ball.zPosition = 1
        ball.position = .init(x: frame.minX + 50, y: frame.midY)
        ball.fillColor = PlayerSettings.theme.inverseColor()
        ball.lineCap = .round
        ball.lineJoin = .round
        return ball
    }()
    
    lazy var barrier: SKShapeNode = {
        let shape = BarrierFactory().generateBarrier(withRadius: 15)
        shape.position = .init(x: frame.midX + 50, y: frame.midY)
        return shape
    }()
    
    lazy var fingerNode: SKSpriteNode = {
        let asset: Asset = PlayerSettings.theme == .dark ? .icFingerWhite : .icFingerBlack
        let node = asset.asNode
        node.zPosition = 1
        node.position = .init(x: frame.midX + 60, y: frame.midY - 20)
        node.size = .init(width: 60, height: 60)
        return node
    }()
    
    override func didMove(to view: SKView) {
        backgroundColor = PlayerSettings.theme.asColor()
        addChild(ball)
        addChild(barrier)
        
        ball.run(.moveTo(x: frame.midX, duration: 0.5)) { [weak self] in
            guard let `self` = self else { return }
            self.addFingerAndScale()
        }
    }
    
    func addFingerAndScale() {
        addChild(fingerNode)
        fingerNode.run(.repeatForever(.sequence([
            .scale(to: 0.8, duration: 1),
            .scale(to: 1, duration: 1)
        ])))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let barrierArea = barrier.frame.insetBy(dx: -15, dy: -15)
        if barrierArea.contains(location) {
            fingerNode.removeFromParent()
            barrier.removeFromParent()
            ball.run(.moveTo(x: frame.maxX - 50, duration: 0.5), completion: { [weak self] in
                guard let `self` = self else { return }
                let newScene = GameScene(size: self.frame.size)
                newScene.gameDelegate = self.gameDelegate
                self.view?.presentScene(newScene)
            })
        }
    }
}
