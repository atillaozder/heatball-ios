//
//  HeatBall.swift
//  HeatBall
//
//  Created by Atilla Özder on 7.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

// MARK: - HeatBall
class HeatBall: Circle {
    
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
        shapeNode.name = Identifier.player.rawValue
        shapeNode.physicsBody!.isDynamic = true
        shapeNode.physicsBody!.contactTestBitMask = shapeNode.physicsBody!.collisionBitMask
        shapeNode.physicsBody!.velocity = velocity
    }
    
    func add(to scene: SKScene) {
        self.shapeNode.removeFromParent()
        scene.addChild(shapeNode)
    }
        
    func destroy() {
        return
    }

    func reset() {
        self.setColor()
        self.shapeNode.position = .zero
        self.resetSpeed()
    }
        
    func setColor(_ color: HeatBall.Color? = nil) {
        let wrapped = color?.asColor() ?? userSettings.currentMode.inverseColor()
        shapeNode.fillColor = wrapped
        shapeNode.strokeColor = wrapped
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
    
    // MARK: - Color
    enum Color: Int {
        case red1 = 1
        case red2 = 2
        case red3 = 3
        case red4 = 4
        case red5 = 5
        case red6 = 6
        case advRed = 7
        
        func asColor() -> UIColor {
            switch self {
            case .red1:
                return .init(red: 255, green: 205, blue: 210)
            case .red2:
                return .init(red: 239, green: 154, blue: 154)
            case .red3:
                return .init(red: 229, green: 115, blue: 115)
            case .red4:
                return .init(red: 239, green: 83, blue: 80)
            case .red5:
                return .init(red: 244, green: 67, blue: 54)
            case .red6:
                return .init(red: 229, green: 57, blue: 53)
            case .advRed:
                return .init(red: 210, green: 62, blue: 102)
            }
        }
    }
}
