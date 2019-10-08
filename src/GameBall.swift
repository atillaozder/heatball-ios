//
//  GameBall.swift
//  HeatBall
//
//  Created by Atilla Özder on 7.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

class GameBall: Circle {
    
    private var lastPosition = CGPoint.zero

    var velocity: CGVector = .init(dx: 200, dy: 200) {
        didSet {
            shapeNode.physicsBody!.velocity = velocity
        }
    }
    
    var position: CGPoint {
        return shapeNode.position
    }
    
    override init(radius: CGFloat) {
        super.init(radius: radius)
        shapeNode.name = Identifier.gameBall.rawValue
        shapeNode.physicsBody!.isDynamic = true
        shapeNode.physicsBody!.contactTestBitMask = shapeNode.physicsBody!.collisionBitMask
        shapeNode.physicsBody!.velocity = velocity
    }
        
    func destroy() {
        return
    }

    func reset() {
        self.setColor()
        self.shapeNode.position = .zero
        self.resetSpeed()
    }
        
    func setColor(_ color: SKColor? = nil) {
        let ballColor = color != nil ? color! : userSettings.currentTheme.inverseColor()
        shapeNode.strokeColor = ballColor
        shapeNode.fillColor = ballColor
    }
    
    func add(to scene: SKScene) {
        self.shapeNode.removeFromParent()
        scene.addChild(shapeNode)
    }
    
    func increaseSpeed() {
        self.velocity = CGVector(dx: velocity.dx + 30, dy: velocity.dy + 30)
    }
    
    func resetSpeed() {
        self.velocity = .init(dx: 200, dy: 200)
    }
    
    func updateLastPosition() {
        if shapeNode.position.x == lastPosition.x {
            shapeNode.run(
                .moveTo(
                    x: shapeNode.position.x + 5,
                    duration: 0.1))
        }
        
        if shapeNode.position.y == lastPosition.y {
            shapeNode.run(
                .moveTo(
                    y: shapeNode.position.y + 5,
                    duration: 0.1))
        }
        
        lastPosition = shapeNode.position
    }
}
