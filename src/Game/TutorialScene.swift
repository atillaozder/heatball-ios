//
//  TutorialScene.swift
//  HeatBall
//
//  Created by Atilla Özder on 8.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

class TutorialScene: Scene {
        
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
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupScene()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        touchesEnd(at: location)
    }
    
    func setupScene() {
        backgroundColor = userSettings.currentTheme.asColor()
        presentDescription()
        
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
    
    func touchesEnd(at location: CGPoint) {
        guard childNode(withIdentifier: .tutorialHand) != nil else { return }
        
        let area = shape.frame.insetBy(dx: -15, dy: -15)
        if area.contains(location) {
            shape.removeFromParent()
            [Identifier.tutorialHand,
             Identifier.tutorialDesc1,
             Identifier.tutorialDesc2].forEach {
                childNode(withIdentifier: $0)?.removeFromParent()
            }
            
            let move = SKAction.move(
                to: .init(x: frame.minX, y: frame.minY),
                duration: 1)
            
            ball.node.run(move) { [weak self] in
                guard let `self` = self else { return }
                let scene = GameScene(size: self.frame.size)
                scene.sceneDelegate = self.sceneDelegate
                scene.safeAreaInsets = self.safeAreaInsets
                
                self.view?.presentScene(scene)

                if !userSettings.isTutorialPresented {
                    userSettings.tutorialPresented()
                    scene.state.enter(Playing.self)
                }
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
    
    func presentDescription() {
        let first = SKLabelNode.defaultLabel
        first.position = .init(x: frame.midX, y: frame.maxY - 120)
        first.text = "Clear shapes to"
        first.horizontalAlignmentMode = .center
        first.name = Identifier.tutorialDesc1.rawValue
        
        let second = SKLabelNode.defaultLabel
        second.position = .init(x: frame.midX, y: frame.maxY - 150)
        second.text = "keep the ball cold"
        second.horizontalAlignmentMode = .center
        second.name = Identifier.tutorialDesc2.rawValue
        
        addChild(first)
        addChild(second)
    }
}
