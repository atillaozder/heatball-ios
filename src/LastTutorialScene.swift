//
//  LastTutorialScene.swift
//  HeatBall
//
//  Created by Atilla Özder on 8.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

class LastTutorialScene: TutorialScene {
    
    lazy var ball: GameBall = {
        let ball = GameBall(radius: 25 / 2)
        let color = userSettings.currentTheme.inverseColor()
        ball.node.fillColor = color
        ball.node.strokeColor = color
        ball.node.position = .init(x: frame.maxX, y: frame.maxY)
        ball.node.physicsBody!.affectedByGravity = false
        ball.node.physicsBody!.isDynamic = false
        return ball
    }()
    
    lazy var shape: SKShapeNode = {
        let shape = Pentagon(radius: 15).node
        shape.position = .init(x: frame.midX, y: frame.midY)
        return shape
    }()
    
    override func setupScene() {
        super.setupScene()
        ball.add(to: self)
        addChild(shape)
        
        let move = SKAction.move(
            to: .init(x: frame.midX + 30, y: frame.midY + 60),
            duration: 1.0)
        
        ball.node.run(move) { [weak self] in
            guard let `self` = self else { return }
            self.presentDescription()
            self.presentHand()
        }
    }
    
    override func presentNextButton() {
        return
    }
    
    override func touchesEnd(at location: CGPoint) {
        super.touchesEnd(at: location)
        guard childNode(withIdentifier: .tutorialHand) != nil else { return }
        
        let area = shape.frame.insetBy(dx: -15, dy: -15)
        if area.contains(location) {
            shape.removeFromParent()
            [Identifier.tutorialHand,
             Identifier.tutorialDesc1,
             Identifier.tutorialDesc2,
             Identifier.tutorialDesc3].forEach {
                childNode(withIdentifier: $0)?.removeFromParent()
            }
            
            let move = SKAction.move(
                to: .init(x: frame.minX, y: frame.minY),
                duration: 1)
            
            ball.node.run(move) { [weak self] in
                guard let `self` = self else { return }
                let newScene = GameScene(size: self.frame.size)
                newScene.sceneDelegate = self.sceneDelegate
                newScene.safeAreaInsets = self.safeAreaInsets
                self.view?.presentScene(newScene)
            }
        }
    }
    
    private func presentHand() {
        let asset: Asset = userSettings.currentTheme == .dark ?
            .icWhiteHand :
            .icBlackHand
        let hand = asset.asNode
        hand.zPosition = 1
        hand.name = Identifier.tutorialHand.rawValue
        hand.position = .init(x: frame.midX + 12.5, y: frame.midY - 25)
        hand.size = .init(width: 80, height: 80)

        addChild(hand)
        hand.run(.repeatForever(.sequence([
            .scale(to: 0.8, duration: 1),
            .scale(to: 1, duration: 1)
        ])))
    }
    
    override func presentDescription() {
        let first = SKLabelNode.defaultLabel
        first.position = .init(x: frame.midX, y: frame.maxY - 120)
        first.text = "Clear the shapes to"
        first.name = Identifier.tutorialDesc1.rawValue
        
        let second = SKLabelNode.defaultLabel
        second.position = .init(x: frame.midX, y: frame.maxY - 150)
        second.text = "prevent ball to heat"
        second.name = Identifier.tutorialDesc2.rawValue
        
        let third = SKLabelNode.defaultLabel
        third.position = .init(x: frame.midX, y: frame.maxY - 180)
        third.text = "and get more score"
        third.name = Identifier.tutorialDesc3.rawValue
        
        addChild(first)
        addChild(second)
        addChild(third)
    }
}
