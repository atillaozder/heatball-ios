//
//  Shape.swift
//  HeatBall
//
//  Created by Atilla Özder on 7.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

// MARK: - ShapeConvertible
protocol ShapeConvertible {
    func asShape(radius: CGFloat) -> Shape
}

// MARK: - Shapes
enum Shapes: Int, ShapeConvertible {
    case rectangle = 0
    case square = 1
    case pentagon = 2
    case hexagon = 3
    case circle = 4
    
    func asShape(radius: CGFloat) -> Shape {
        switch self {
        case .rectangle:
            return Rectangle(radius: radius)
        case .square:
            return Square(radius: radius)
        case .circle:
            return Circle(radius: radius)
        case .hexagon:
            return Hexagon(radius: radius)
        case .pentagon:
            return Pentagon(radius: radius)
        }
    }
}

// MARK: - Shape
protocol Shape {
    var node: SKShapeNode { get }
    func createPath(sides: Int, radius: CGFloat, offset: CGFloat) -> CGPath
    func createPhysicsBody(path: CGPath) -> SKPhysicsBody
}

extension Shape {
    func createPath(sides:Int, radius: CGFloat, offset: CGFloat = 0) -> CGPath {
        let path = CGMutablePath()
        let angle = (360 / CGFloat(sides)).radians()
        let r = radius
        var i = 0
        var points = [CGPoint]()
        while i <= sides {
            let xpo = r * cos(angle * CGFloat(i) - offset.radians())
            let ypo = r * sin(angle * CGFloat(i) - offset.radians())
            points.append(CGPoint(x: xpo, y: ypo))
            i += 1
        }
        
        let cpg = points[0]
        path.move(to: cpg)
        points.forEach { path.addLine(to: $0) }
        path.closeSubpath()
        return path
    }
    
    func createPhysicsBody(path: CGPath) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(edgeChainFrom: path)
        physicsBody.friction = 0
        physicsBody.angularDamping = 0
        physicsBody.linearDamping = 0
        physicsBody.restitution = 1
        physicsBody.allowsRotation = false
        physicsBody.isDynamic = false
        physicsBody.affectedByGravity = false
        return physicsBody
    }
}
