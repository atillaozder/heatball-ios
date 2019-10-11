//
//  GameScene.swift
//  Ball
//
//  Created by Atilla Özder on 5.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit
import GameplayKit

var playedGameCount: Double = 0
let userSettings = UserSettings()

class GameScene: Scene {
    
    lazy var rewardBasedVideoAdPresented = false
    private var liveNodes = [SKShapeNode]()
    private lazy var blockManager = BlockManager(scene: self)

    var heat: Int = 0 {
        didSet {
            if state.currentState is Playing && heat > 0 {
                if userSettings.isSoundEnabled {
                    run(userSettings.sound)
                }
                
                liveNodes.last?.removeFromParent()
                liveNodes.removeLast(1)
                
                guard let tone = HeatTone(rawValue: heat)
                    else {
                        state.enter(GameOver.self)
                        return
                }
                
                ball.setColor(tone.asColor())
                speedUpGame()

                if tone == .red8 {
                    let _ = rewardBasedVideoAdPresented ?
                        state.enter(GameOver.self) :
                        state.enter(Reward.self)
                } else if tone == .advRed {
                    state.enter(GameOver.self)
                }
            }
        }
    }
    
    var score: Int = 0 {
        didSet {
            if let label = childNode(withIdentifier: .gameScore) as? SKLabelNode {
                let text = "Score: \(score)"
                let font = UIFont(name: label.fontName!, size: label.fontSize)!
                let size = (text as NSString)
                    .size(withAttributes: [.font: font])
                
                label.position = CGPoint(
                    x: frame.maxX - (size.width / 2) - 8,
                    y: frame.maxY - 24 - safeAreaInsets.top)
                label.text = text
            }
        }
    }
    
    lazy var state: GKStateMachine = GKStateMachine(
        states: [
            WaitingForTap(scene: self),
            Playing(scene: self),
            GameOver(scene: self),
            Reward(scene: self),
            Settings(scene: self)
    ])
    
    lazy var ball: GameBall = {
        return GameBall(radius: 25 / 2)
    }()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        userSettings.tutorialPresented()
        self.updateTheme()
        self.physicsWorld.contactDelegate = self
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        borderBody.restitution = 1
        borderBody.angularDamping = 0
        borderBody.linearDamping = 0
        self.physicsBody = borderBody
        self.physicsWorld.gravity = .zero
        
        ball.add(to: self)
        state.enter(WaitingForTap.self)

        blockManager.runSequence()
        run(.repeatForever(.sequence([
            .wait(forDuration: 15),
            .run(speedUpGame)
        ])))
        
        run(.repeatForever(.sequence([
            .wait(forDuration: 2),
            .run(ball.updateLastPosition)
        ])))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let node = self.atPoint(touch.location(in: self))
        
        switch state.currentState {
        case is WaitingForTap:
            touchesBeganInWaitingForTapMode(node)
        case is GameOver:
            let newScene = GameScene(size: frame.size)
            sceneDelegate?.scene(self, didCreateNewScene: newScene)
            newScene.safeAreaInsets = self.safeAreaInsets
            newScene.scaleMode = UIDevice.current.scaleMode
            self.view?.presentScene(newScene)
        case is Settings:
            touchesBeganInSettingsMode(node)
        case is Reward:
            touchesBeganInRewardMode(node)
        default:
            break
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if state.currentState is Playing {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            if blockManager.removeBlock(at: location) {
                score += 1
            }
        }
    }
    
    func touchesBeganInWaitingForTapMode(_ node: SKNode) {
        switch node.name {
        case Identifier.settings.rawValue:
            state.enter(Settings.self)
        case Identifier.play.rawValue:
            state.enter(Playing.self)
        default:
            break
        }
    }
    
    func touchesBeganInRewardMode(_ node: SKNode) {
        switch node.name {
        case Identifier.continueWithVideoButton.rawValue,
             Identifier.continueWithVideoLabel.rawValue:
            sceneDelegate?.scene(self, shouldPresentRewardBasedVideoAd: rewardBasedVideoAdPresented)
        case Identifier.playAnotherGameButton.rawValue,
             Identifier.playAnotherGameLabel.rawValue:
            state.enter(GameOver.self)
        default:
            break
        }
    }
    
    func touchesBeganInSettingsMode(_ node: SKNode) {
        switch node.name {
        case Identifier.settings.rawValue:
            state.enter(WaitingForTap.self)
        case Identifier.play.rawValue:
            state.enter(WaitingForTap.self)
            state.enter(Playing.self)
        default:
            nodeTapped(node)
        }
    }
    
    private func nodeTapped(_ node: SKNode) {
        if let name = node.name, let identifier = Identifier(rawValue: name) {
            switch identifier {
            case .sound:
                userSettings.toggleSound()
                let asset: Asset = userSettings.isSoundEnabled ?
                    .icSoundEnabled :
                    .icSoundDisabled
                let spriteNode = node as! SKSpriteNode
                spriteNode.texture = SKTexture(imageNamed: asset.rawValue)
            case .rateUs:
                sceneDelegate?.scene(self, didTapRateNode: node)
            case .theme:
                userSettings.toggleTheme()
            case .tutorial:
                let newScene = TutorialScene(size: frame.size)
                self.presentTutorial(newScene)
            default:
                break
            }
        }
    }
    
    private func presentScore() {
        self.childNode(withName: Identifier.gameScore.rawValue)?.removeFromParent()
        let score = SKLabelNode.defaultLabel
        score.text = "Score: 0"
        score.name = Identifier.gameScore.rawValue
        score.zPosition = -1
        score.position = CGPoint(
            x: frame.maxX - 56,
            y: frame.maxY - 24 - safeAreaInsets.top)
        self.addChild(score)
    }
        
    func updateTheme() {
        let currentTheme = userSettings.currentTheme
        ball.setColor()
        self.backgroundColor = currentTheme.asColor()
                
        let identifiers: [Identifier] = [.totalScore, .bestScore, .gameScore]
        identifiers.compactMap { (identifier) -> SKLabelNode? in
            return childNode(withName: identifier.rawValue) as? SKLabelNode
        }.forEach { (label) in
            label.fontColor = currentTheme.inverseColor()
        }
    }
        
    func initializeGame() {
        score = 0
        resetGame()
        ball.add(to: self)
        presentScore()
        presentLives()
    }
    
    func startGame() {
        let posX = frame.minX + LiveCircle.diameter
        let posY = frame.maxY - LiveCircle.diameter - 8
        presentLive(in: .init(x: posX, y: posY))
        ball.setColor(HeatTone.advRed.asColor())
        ball.resetSpeed()
        blockManager.reset()
        self.isPaused = false
    }
    
    func pauseGame() {
        self.isPaused = true
    }
    
    func gameOver() {
        self.isPaused = false
        playedGameCount += 1
        sceneDelegate?.scene(self, shouldPresentInterstitial: playedGameCount.truncatingRemainder(dividingBy: 3) == 0)
        userSettings.setHighestScore(score)
        resetGame()
        state.enter(WaitingForTap.self)
    }
    
    private func resetGame() {
        heat = 0
        blockManager.reset()
        ball.reset()
        childNode(withIdentifier: .gameScore)?.removeFromParent()
        removeLives()
        rewardBasedVideoAdPresented = false
    }
    
    private func presentLives() {
        removeLives()
        let posX = frame.minX + LiveCircle.diameter + 4
        let posY = frame.maxY - LiveCircle.diameter - 8
        
        for i in 0..<8 {
            let rodPosX = posX + ((LiveCircle.diameter + 4) * CGFloat(i))
            presentLive(in: .init(x: rodPosX, y: posY))
        }
    }

    private func presentLive(in origin: CGPoint) {
        var mutableOrigin = origin
        mutableOrigin.y -= safeAreaInsets.top
        let circle = LiveCircle(origin: mutableOrigin)
        self.liveNodes.append(circle.node)
        self.addChild(circle.node)
    }
    
    private func removeLives() {
        self.liveNodes.forEach { $0.removeFromParent() }
        self.liveNodes = []
    }
        
    private func speedUpGame() {
        if state.currentState is Playing {
            blockManager.decreaseDuration()
            ball.increaseSpeed()
        }
    }
}

// MARK: SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if nodeA?.name == Identifier.block.rawValue {
            blockManager.removeBlock(nodeA as! SKShapeNode)
            heat += 1
            return
        }
        
        if nodeB?.name == Identifier.block.rawValue {
            blockManager.removeBlock(nodeB as! SKShapeNode)
            heat += 1
            return
        }
    }
}
