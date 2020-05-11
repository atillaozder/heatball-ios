//
//  GameScene.swift
//  Heatball
//
//  Created by Atilla Özder on 10.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit
import GameplayKit

// MARK: - SceneDelegate
protocol SceneDelegate: AnyObject {
    func scene(_ scene: GameScene, didUpdateScore score: Double)
    func scene(_ scene: GameScene, willUpdateLifeCount count: Int)
    func scene(_ scene: GameScene, didFinishGameWithScore score: Double)
    func scene(_ scene: GameScene, didUpdateGameState state: GameState)
}

// MARK: - GameScene
class GameScene: SKScene {
    
    // MARK: - Properties
    
    /// safe area insets of the game view controller
    lazy var insets: UIEdgeInsets = .zero
    private var gotReward: Bool = false
    private var gameOver: Bool = false
    
    private var stayPaused = false
    
    override var isPaused: Bool {
        get {
            return super.isPaused
        } set {
            if (!stayPaused) {
                super.isPaused = newValue
            }
            stayPaused = false
        }
    }
    
    var gameStarted: Bool {
        return true
    }
    
    weak var sceneDelegate: SceneDelegate?
    fileprivate lazy var blockManager = BlockManager(scene: self)
    let gameHelper = GameHelper()
    
    lazy var player: Player = {
        return Player(radius: 25 / 2)
    }()
    
    var score: Double = 0 {
        willSet (newScore) {
            guard newScore > 0 else { return }
            if newScore.truncatingRemainder(dividingBy: 100) == 0 {
                self.updateDifficulty()
            }
        } didSet {
            sceneDelegate?.scene(self, didUpdateScore: score)
        }
    }
    
    var lifeCount: Int = 3 {
        willSet {
            sceneDelegate?.scene(self, willUpdateLifeCount: newValue)
            if newValue <= 0 {
                gameDidFinish()
            }
        }
    }
    
    // MARK: - Game Life Cycle
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        resetGame()
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = UIColor.background.darker(by: 10)        
        initiateGame()
        
        let physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsBody.friction = 0
        physicsBody.restitution = 1
        physicsBody.angularDamping = 0
        physicsBody.linearDamping = 0
        
        self.physicsBody = physicsBody
        self.physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
        
        player.add(toScene: self)
        blockManager.initiateBlockSeq()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard !isPaused else { return }
        guard let touch = touches.first else { return }
        if blockManager.removeBlock(at: touch.location(in: self)) {
            score += 1
        }
    }
    
    func initiateGame() {
        GameManager.shared.gameCount += 1
        player.add(toScene: self)
        
        run(.repeatForever(.sequence([
            .wait(forDuration: 15),
            .run(updateDifficulty)
        ])))
    }
    
    fileprivate func stopGame() {
        if !gotReward {
            self.setPausedAndNotify(true)
            self.sceneDelegate?.scene(self, didUpdateGameState: .advertisement)
        } else {
            self.sceneDelegate?.scene(self, didUpdateGameState: .home)
        }
    }
    
    func gameDidFinish() {
        self.gameOver = true
        self.player.node.removeFromParent()
        self.sceneDelegate?.scene(self, didFinishGameWithScore: score)
        self.stopGame()
    }
    
    func didGetReward() {
        AudioPlayer.shared.playMusic()
        player.add(toScene: self)
        
        self.lifeCount = max(1, lifeCount)
        self.gameOver = false
        self.setPausedAndNotify(false)
    }
    
    func willPresentRewardBasedVideoAd() {
        self.gotReward = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.enumerateChildNodes(withName: GameObject.block.rawValue) { (node, ptr) in
                node.removeFromParent()
            }
        }
    }
    
    func setStayPaused() {
        if (super.isPaused) {
            self.stayPaused = true
        }
    }
    
    func setPausedAndNotify(_ isPaused: Bool) {
        self.isPaused = isPaused
        self.blockManager.didChangePauseState(isPaused)
    }
    
    func updateDifficulty() {
        blockManager.updateDifficulty()
        player.updateDifficulty()
    }
    
    func updateLifeCount() {
        lifeCount = max(0, lifeCount - 1)
        if let color = Player.Color(rawValue: lifeCount) {
            player.setColor(color)
            updateDifficulty()
        }
    }
    
    // MARK: - Private Helper Methods
    private func resetGame() {
        self.removeAllActions()
        self.removeAllChildren()
        blockManager.reset()
        player.reset()
    }
}

// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let isPlayer = contact.bodyA.category == .player
        let bodyA = isPlayer ? contact.bodyA : contact.bodyB
        let bodyB = isPlayer ? contact.bodyB : contact.bodyA
        
        switch (bodyA.category, bodyB.category) {
        case (.player, .block):
            if let block = bodyB.node {
                if lifeCount > 1 {
                    gameHelper.playEffect(.pop, in: self)
                }
                
                blockManager.removeBlock(block)
                updateLifeCount()
            }
        default:
            break
        }
    }
}

// MARK: - SKPhysicsBody
extension SKPhysicsBody {
    var category: Category {
        return Category(rawValue: categoryBitMask) ?? .none
    }
}
