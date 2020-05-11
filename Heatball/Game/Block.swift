//
//  Block.swift
//  HeatBall
//
//  Created by Atilla Özder on 7.10.2019.
//  Copyright © 2020 Atilla Özder. All rights reserved.
//

import SpriteKit

// MARK: - Block
class Block {
    
    var radius: CGFloat
    
    init(radius: CGFloat) {
        self.radius = radius
    }
    
    lazy var node: SKShapeNode = {
        let rad: CGFloat = radius == 0 ? .random(in: 10...35) / 2 : radius
        let node = SKShapeNode(circleOfRadius: rad)
        node.fillColor = UIColor.random
        node.strokeColor = UIColor.random.darker()
        node.lineWidth = 2
        node.name = GameObject.block.rawValue
        node.zPosition = 1
        node.lineJoin = .round
        node.lineCap = .round
        
        let physicsBody = SKPhysicsBody(circleOfRadius: rad)
        physicsBody.friction = 0
        physicsBody.angularDamping = 0
        physicsBody.linearDamping = 0
        physicsBody.restitution = 1
        physicsBody.allowsRotation = true
        physicsBody.isDynamic = false
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = Category.block.rawValue
        physicsBody.contactTestBitMask = Category.player.rawValue
        node.physicsBody = physicsBody
        return node
    }()
}
