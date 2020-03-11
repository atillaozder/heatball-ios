//
//  TutorialScene.swift
//  HeatBall
//
//  Created by Atilla Özder on 8.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

// MARK: - TutorialScene

class TutorialScene: Scene {
    
    private let desc1ID = "desc1"
    private let desc2ID = "desc2"
    private let handID = "hand"
        
    // MARK: - Variables
    lazy var ball: HeatBall = {
        let ball = HeatBall(radius: 25 / 2)
        let color = userSettings.currentMode.inverseColor()
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
    
    // MARK: - Game Life Cycle
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = userSettings.selectedColor
        presentDescription()
        
        ball.add(to: self)
        addChild(shape)
        
        let move = SKAction.move(
            to: .init(x: frame.midX + 30, y: frame.midY + 60),
            duration: 1.0)
        
        ball.node.run(move) { [weak self] in
            guard let `self` = self else { return }
            self.presentDescription()
            self.presentPlayerHand()
        }
    }
    
    // MARK: - View Initializations
    private func presentPlayerHand() {
        let node = Asset.icHand.asNode
        node.zPosition = 1
        node.name = handID
        node.position = .init(x: frame.midX + 4, y: frame.midY - 30)
        node.setScale(1.5)
        
        addChild(node)
        node.run(.repeatForever(.sequence([
            .scale(to: 1.3, duration: 1),
            .scale(to: 1.5, duration: 1)
        ])))
    }
    
    private func presentDescription() {
        let label1 = SKViewFactory().buildLabel()
        label1.position = .init(x: frame.midX, y: frame.maxY - 120)
        label1.text = "Clear shapes to"
        label1.horizontalAlignmentMode = .center
        label1.name = desc1ID
        
        let label2 = SKViewFactory().buildLabel()
        label2.position = .init(x: frame.midX, y: frame.maxY - 150)
        label2.text = "keep the ball cold"
        label2.horizontalAlignmentMode = .center
        label2.name = desc2ID
        
        addChild(label1)
        addChild(label2)
    }
    
    // MARK: - Touch Handling
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else { return }
        touchesEnd(at: touch.location(in: self))
    }
        
    private func touchesEnd(at location: CGPoint) {
        guard childNode(withName: handID) != nil else { return }
        
        let area = shape.frame.insetBy(dx: -15, dy: -15)
        if area.contains(location) {
            shape.removeFromParent()
            [handID, desc1ID, desc2ID].forEach {
                childNode(withName: $0)?.removeFromParent()
            }
            
            let move = SKAction.move(
                to: .init(x: frame.minX, y: frame.minY),
                duration: 1)
            
            ball.node.run(move) { [weak self] in
                guard let `self` = self else { return }
                let scene = GameScene(size: self.frame.size)
                scene.sceneDelegate = self.sceneDelegate
                scene.insets = self.insets
                
                self.view?.presentScene(scene)

                if !userSettings.isTutorialPresented {
                    userSettings.setTutorialPresented()
                    scene.state.enter(PlayingState.self)
                }
            }
        }
    }
}
