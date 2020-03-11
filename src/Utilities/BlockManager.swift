//
//  BlockManager.swift
//  HeatBall
//
//  Created by Atilla Özder on 7.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

// MARK: - BlockManager
final class BlockManager {
    
    weak var scene: GameScene!
    private let key = "add_barrier_action_key"
    private var blocks: Set<SKShapeNode>
    private var duration: TimeInterval = 1.0 {
        didSet {
            runSequence()
        }
    }
    
    init(scene: GameScene) {
        self.scene = scene
        self.blocks = Set()
    }
        
    func runSequence() {
        scene.removeAction(forKey: key)
        let sequence = SKAction.sequence([
            .wait(forDuration: duration),
            .run(addBlock)
        ])
        scene.run(.repeatForever(sequence),
                  withKey: key)
    }
    
    func block(at location: CGPoint) -> SKShapeNode? {
        return blocks.filter { (block) -> Bool in
            return block.frame
                .insetBy(dx: -15, dy: -15)
                .contains(location)
        }.first
    }
    
    func addBlock() {
        let rad = CGFloat.random(in: 10...35) / 2
        let newBlock = Shapes(rawValue: Int.random(in: 0...4))!
            .asShape(radius: rad)
            .node
        
        if newBlock.fillColor == userSettings.selectedColor {
            return
        }
        
        var location = self.randomLocation(size: newBlock.frame.size)
        let ball = scene!.ball.node
        var area = ball.frame.insetBy(dx: -20, dy: -20)
        
        // Position should not be near of game ball
        while area.contains(location) {
            area = ball.frame.insetBy(dx: -20, dy: -20)
            location = self.randomLocation(size: newBlock.frame.size)
        }
        
        newBlock.position = location
        for block in self.blocks {
            if block.intersects(newBlock) {
                return
            }
        }
        
        newBlock.setScale(0)
        scene.addChild(newBlock)
        newBlock.run(.scale(to: 1, duration: 0.05))
        self.blocks.insert(newBlock)
    }
    
    func removeBlock(_ block: SKShapeNode) {
        block.physicsBody!.categoryBitMask = 0x0
        block.removeFromParent()
        blocks.remove(block)
    }
        
    @discardableResult
    func removeBlock(at location: CGPoint) -> Bool {
        if let node = block(at: location) {
            self.removeBlock(node)
            return true
        } else {
            return false
        }
    }
    
    func reset() {
        blocks.forEach { $0.removeFromParent() }
        blocks = Set()
        duration = 1.0
    }
    
    func setDuration() {
        duration = max(duration - 0.1, 0.5)
    }
    
    private func randomLocation(size: CGSize) -> CGPoint {
        let sceneSize = scene.size
        var xPos = CGFloat(Float(arc4random()) / Float(UInt32.max)) * sceneSize.width
        var yPos = CGFloat(Float(arc4random()) / Float(UInt32.max)) * sceneSize.height
        
        if xPos < scene.frame.midX {
            xPos += size.width
        } else if xPos > scene.frame.midX {
            xPos -= size.width
        }
        
        if yPos < scene.frame.midY {
            yPos += size.height
        } else if yPos > scene.frame.midY {
            yPos -= size.height
        }
        
        return CGPoint(x: xPos, y: yPos)
    }
}
