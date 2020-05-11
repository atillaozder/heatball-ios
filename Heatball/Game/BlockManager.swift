//
//  BlockManager.swift
//  Heatball
//
//  Created by Atilla Özder on 7.10.2019.
//  Copyright © 2020 Atilla Özder. All rights reserved.
//

import SpriteKit
import GameKit

// MARK: - BlockManager
final class BlockManager {
    
    weak var scene: GameScene!
    
    private let addBlockKey = "addBlock"
    private var blocks: Set<SKNode>
    private var duration: TimeInterval = 1.0 {
        didSet {
            initiateBlockSeq()
        }
    }
    
    init(scene: GameScene) {
        self.scene = scene
        self.blocks = Set()
    }
        
    // MARK: - Helpers
    
    func initiateBlockSeq() {
        scene.removeAction(forKey: addBlockKey)
        let sequence = SKAction.sequence([
            .wait(forDuration: duration),
            .run(addBlock, queue: .global())
        ])
        scene.run(.repeatForever(sequence), withKey: addBlockKey)
    }
    
    func block(at location: CGPoint) -> SKNode? {
        return blocks.filter { (block) -> Bool in
            return block.frame
                .insetBy(dx: -15, dy: -15)
                .contains(location)
        }.first
    }
    
    func addBlock() {
        let radius = CGFloat.random(in: 10...35) / 2
        let newBlock = Block(radius: radius).node

        var position = self.randomPosition()
        let player = scene.player.node
        var area = player.frame.insetBy(dx: -20, dy: -20)
        
        while area.contains(position) {
            area = player.frame.insetBy(dx: -20, dy: -20)
            position = self.randomPosition()
        }
        
        newBlock.position = position
        for block in self.blocks {
            if block.intersects(newBlock) {
                return
            }
        }
        
        newBlock.setScale(0)
        DispatchQueue.main.async {
            self.scene.addChild(newBlock)
            newBlock.run(.scale(to: 1, duration: 0.05))
            self.blocks.insert(newBlock)
        }
    }
    
    func removeBlock(_ block: SKNode) {
        block.physicsBody?.categoryBitMask = 0x0
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
    
    func updateDifficulty() {
        duration = max(duration - 0.1, 0.5)
    }
    
    func didChangePauseState(_ isPaused: Bool) {
        if let seq = scene.action(forKey: addBlockKey) {
            seq.speed = isPaused ? 0 : 1
        }
    }
    
    private func randomPosition() -> CGPoint {
        let x = CGFloat(Float(arc4random()) / Float(UInt32.max)) * scene.size.width
        let y = CGFloat(Float(arc4random()) / Float(UInt32.max)) * scene.size.height
        return CGPoint(x: x, y: y)
    }
}
