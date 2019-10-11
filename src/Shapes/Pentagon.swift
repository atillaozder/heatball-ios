//
//  Pentagon.swift
//  HeatBall
//
//  Created by Atilla Özder on 7.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

class Pentagon: Shape {
    
    var radius: CGFloat
    var node: SKShapeNode {
        return shapeNode
    }
    
    init(radius: CGFloat) {
        self.radius = radius
    }
    
    lazy var shapeNode: SKShapeNode = {
        let cgPath = self.createPath(sides: 5, radius: radius)
        let shape = SKShapeNode(path: cgPath)
        let color = SKColor.random
        shape.fillColor = color
        shape.strokeColor = color
        shape.zPosition = 1
        shape.name = Identifier.block.rawValue
        shape.physicsBody = createPhysicsBody(path: cgPath)
        return shape
    }()
}
