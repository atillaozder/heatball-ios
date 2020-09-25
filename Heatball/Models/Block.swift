//
//  Block.swift
//  HeatBall
//
//  Created by Atilla Özder on 7.10.2019.
//  Copyright © 2020 Atilla Özder. All rights reserved.
//

import SpriteKit
import RandomColorSwift

// MARK: - Block

class Block {
    
    var radius: CGFloat
    
    init(radius: CGFloat) {
        self.radius = radius
    }
    
    lazy var node: SKShapeNode = {
        let rad: CGFloat = radius == 0 ? .random(in: 10...35) / 2 : radius
        let shapeNode = SKShapeNode(circleOfRadius: rad)
        let color = randomColor(hue: .random, luminosity: .light)
        shapeNode.fillColor = color
        shapeNode.strokeColor = color
        shapeNode.lineWidth = 2
        shapeNode.name = Globals.Keys.kBlock.rawValue
        shapeNode.zPosition = 1
        shapeNode.lineJoin = .round
        shapeNode.lineCap = .round
        
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
        shapeNode.physicsBody = physicsBody
        return shapeNode
    }()
}
