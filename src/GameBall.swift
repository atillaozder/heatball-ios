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

    var velocity: CGVector = .init(dx: 300, dy: 300) {
        didSet {
            shapeNode.physicsBody!.velocity = velocity
        }
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
        self.resetVelocity()
    }
        
    func setColor(_ color: SKColor? = nil) {
        let ballColor = color != nil ? color! : userSettings.currentTheme.inverseColor()
        shapeNode.strokeColor = ballColor
        shapeNode.fillColor = ballColor
    }
    
    func add(to scene: GameScene) {
        self.shapeNode.removeFromParent()
        scene.addChild(shapeNode)
    }
    
    func increaseVelocity() {
        self.velocity = CGVector(dx: velocity.dx + 15, dy: velocity.dy + 15)
    }
    
    func resetVelocity() {
        self.velocity = .init(dx: 300, dy: 300)
    }
    
    func updateLastPosition() {
        if shapeNode.position.x == lastPosition.x {
            let location = SKAction.moveTo(x: shapeNode.position.x + 5, duration: 0.1)
            shapeNode.run(location)
        }
        
        if shapeNode.position.y == lastPosition.y {
            let location = SKAction.moveTo(y: shapeNode.position.y + 5, duration: 0.1)
            shapeNode.run(location)
        }
        
        lastPosition = shapeNode.position
    }
}
