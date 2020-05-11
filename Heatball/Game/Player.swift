//
//  Player.swift
//  HeatBall
//
//  Created by Atilla Özder on 7.10.2019.
//  Copyright © 2020 Atilla Özder. All rights reserved.
//

import SpriteKit

// MARK: - Player
class Player: Block {
    
    var position: CGPoint {
        return node.position
    }
    
    var velocity: CGVector = .init(dx: 200, dy: 200) {
        didSet {
            node.physicsBody?.velocity = velocity
        }
    }
    
    override init(radius: CGFloat) {
        super.init(radius: radius)
        node.name = GameObject.player.rawValue
        node.physicsBody?.isDynamic = true
        node.physicsBody?.categoryBitMask = Category.player.rawValue
        node.physicsBody?.contactTestBitMask = Category.block.rawValue
        node.physicsBody?.velocity = velocity
    }
    
    // MARK: - Helpers
    
    func add(toScene scene: SKScene) {
        self.node.removeFromParent()
        self.reset()
        scene.addChild(node)
    }

    func reset() {
        self.node.position = .zero
        self.setColor(.none)
        self.velocity = .init(dx: 200, dy: 200)
    }
        
    func setColor(_ color: Player.Color) {
        let fillColor = color.uiColorRepresentation()
        node.fillColor = fillColor
        node.strokeColor = fillColor
    }

    func updateDifficulty() {
        self.velocity = CGVector(dx: velocity.dx + 30, dy: velocity.dy + 30)
    }
    
    // MARK: - Color
    enum Color: Int {
        case none = 0
        case normal = 1
        case easy = 2

        func uiColorRepresentation() -> UIColor {
            switch self {
            case .none:
                return UIColor(red: 250, green: 250, blue: 250)
            case .easy:
                return .init(red: 239, green: 83, blue: 80)
            case .normal:
                return .init(red: 244, green: 67, blue: 54)
            }
        }
    }
}
