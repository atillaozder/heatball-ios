//
//  Circle.swift
//  HeatBall
//
//  Created by Atilla Özder on 7.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

// MARK: - Circle
class Circle: Shape {
    
    var radius: CGFloat
    var node: SKShapeNode {
        return shapeNode
    }
    
    init(radius: CGFloat) {
        self.radius = radius
    }
    
    lazy var shapeNode: SKShapeNode = {
        let rad: CGFloat = radius == 0 ? .random(in: 10...35) / 2 : radius
        let shape = SKShapeNode(circleOfRadius: rad)
        let color = SKColor.random
        shape.fillColor = color
        shape.strokeColor = color
        shape.name = Identifier.block.rawValue
        shape.zPosition = 1
        shape.lineJoin = .round
        shape.lineCap = .round
        
        let physicsBody = SKPhysicsBody(circleOfRadius: rad)
        physicsBody.friction = 0
        physicsBody.angularDamping = 0
        physicsBody.linearDamping = 0
        physicsBody.restitution = 1
        physicsBody.allowsRotation = true
        physicsBody.isDynamic = false
        physicsBody.affectedByGravity = false
        shape.physicsBody = physicsBody
        return shape
    }()
}
