//
//  GameScene.swift
//  Ball
//
//  Created by Atilla Özder on 5.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit
import GameplayKit

var gameCount: Double = 0
let userSettings = UserSettings()

class GameScene: Scene {
    
    // MARK: - Variables
    lazy var rewardBasedVideoAdPresented = false
    private var liveNodes = [SKShapeNode]()
    private lazy var blockManager = BlockManager(scene: self)

    var heat: Int = 0 {
        didSet {
            if state.currentState is PlayingState && heat > 0 {
                if userSettings.isSoundEnabled {
                    run(sound)
                }
                
                if !liveNodes.isEmpty {
                    liveNodes.last?.removeFromParent()
                    liveNodes.removeLast(1)
                }
                
                guard let color = HeatBall.Color(rawValue: heat) else {
                    state.enter(GameOverState.self)
                    return
                }
                
                ball.setColor(color)
                speedUpGame()
                
                if color == .red6 {
                    let _ = rewardBasedVideoAdPresented ?
                        state.enter(GameOverState.self) :
                        state.enter(RewardState.self)
                } else if color == .advRed {
                    state.enter(GameOverState.self)
                }
            }
        }
    }
    
    var score: Int = 0 {
        didSet {
            if let label = childNode(withIdentifier: .currentScore) as? SKLabelNode {
                let text = "Score: \(score)"
                let font = UIFont(name: label.fontName!, size: label.fontSize)!
                let size = (text as NSString).size(withAttributes: [.font: font])
                
                label.position = CGPoint(
                    x: frame.maxX - (size.width / 2) - 8,
                    y: frame.maxY - 24 - insets.top)
                label.text = text
            }
        }
    }
    
    lazy var state: GKStateMachine = GKStateMachine(
        states: [
            WaitingToPlayState(scene: self),
            PlayingState(scene: self),
            GameOverState(scene: self),
            RewardState(scene: self),
            SettingsState(scene: self)
    ])
    
    lazy var ball: HeatBall = {
        return HeatBall(radius: 25 / 2)
    }()
    
    // MARK: - Game Life Cycle
    override func didMove(to view: SKView) {
        super.didMove(to: view)

        self.updateMode()
        self.setupPhysicsWorld()
        
        ball.add(to: self)
        state.enter(WaitingToPlayState.self)

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
    
    private func setupPhysicsWorld() {
        self.physicsWorld.contactDelegate = self
        let body = SKPhysicsBody(edgeLoopFrom: self.frame)
        body.friction = 0
        body.restitution = 1
        body.angularDamping = 0
        body.linearDamping = 0
        self.physicsBody = body
        self.physicsWorld.gravity = .zero
    }
    
    func initializeGame() {
        score = 0
        resetGame()
        ball.add(to: self)
        presentScore()
        presentLives()
    }
    
    func startGame() {
        let posX = frame.minX + Life.diameter
        let posY = frame.maxY - Life.diameter - 8
        presentLive(in: .init(x: posX, y: posY))
        ball.setColor(.advRed)
        ball.resetSpeed()
        blockManager.reset()
        self.isPaused = false
    }
    
    func pauseGame() {
        self.isPaused = true
    }
    
    func endGame() {
        self.isPaused = false
        gameCount += 1
        let shouldPresent = gameCount.truncatingRemainder(dividingBy: 2) == 0
        sceneDelegate?.scene(self, shouldPresentInterstitial: shouldPresent)
        userSettings.setBestScore(score)
        resetGame()
        state.enter(WaitingToPlayState.self)
    }
    
    private func resetGame() {
        heat = 0
        blockManager.reset()
        ball.reset()
        childNode(withIdentifier: .currentScore)?.removeFromParent()
        removeLives()
        rewardBasedVideoAdPresented = false
    }
    
    // MARK: - View Initializations
    private func presentScore() {
        childNode(withIdentifier: .currentScore)?.removeFromParent()
        let score = SKViewFactory().buildLabel(withIdentifier: .currentScore)
        score.text = "Score: 0"
        score.zPosition = 999
        score.position = CGPoint(x: frame.maxX - 56, y: frame.maxY - 24 - insets.top)
        self.addChild(score)
    }
    
    private func presentLives() {
        removeLives()
        let posX = frame.minX + Life.diameter + 4
        let posY = frame.maxY - Life.diameter - 8
        
        for i in 0..<6 {
            let rodPosX = posX + ((Life.diameter + 4) * CGFloat(i))
            presentLive(in: .init(x: rodPosX, y: posY))
        }
    }
    
    private func presentLive(in origin: CGPoint) {
        var mutableOrigin = origin
        mutableOrigin.y -= insets.top
        let circle = Life(origin: mutableOrigin)
        self.liveNodes.append(circle.node)
        self.addChild(circle.node)
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let node = self.atPoint(touch.location(in: self))
        
        switch state.currentState {
        case is WaitingToPlayState:
            handleTouchWaitingForTapState(node)
        case is GameOverState:
            handleTouchGameOverState()
        case is SettingsState:
            handleTouchSettingsState(node)
        case is RewardState:
            handleTouchRewardState(node)
        default:
            break
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if state.currentState is PlayingState {
            guard let touch = touches.first else { return }
            if blockManager.removeBlock(at: touch.location(in: self)) {
                score += 1
            }
        }
    }
        
    private func handleTouchWaitingForTapState(_ node: SKNode) {
        guard let id = Identifier(rawValue: node.name ?? "") else { return }
        switch id {
        case .settings:
            state.enter(SettingsState.self)
        case .play:
            userSettings.isTutorialPresented ? enterPlayingState() : presentTutorial()
        default:
            break
        }
    }
    
    private func enterPlayingState() {
        state.enter(PlayingState.self)
    }
    
    private func handleTouchGameOverState() {
        let newScene = GameScene(size: frame.size)
        sceneDelegate?.scene(self, didCreateNewScene: newScene)
        newScene.insets = self.insets
        newScene.scaleMode = UIDevice.current.scaleMode
        self.view?.presentScene(newScene)
    }
    
    private func handleTouchSettingsState(_ node: SKNode) {
        guard let id = Identifier(rawValue: node.name ?? "") else {
            nodeTapped(node)
            return
        }
        
        switch id {
        case .settings:
            state.enter(WaitingToPlayState.self)
        case .play:
            state.enter(WaitingToPlayState.self)
            enterPlayingState()
        default:
            nodeTapped(node)
        }
    }
    
    private func handleTouchRewardState(_ node: SKNode) {
        let factory = SKViewFactory()
        switch node.name {
        case factory.continueVideoBtn, factory.continueVideoLbl:
            sceneDelegate?.scene(self, shouldPresentRewardBasedVideoAd: rewardBasedVideoAdPresented)
        case factory.newGameBtn, factory.newGameLbl:
            state.enter(GameOverState.self)
        default:
            break
        }
    }
    
    private func nodeTapped(_ node: SKNode) {
        guard let id = Identifier(rawValue: node.name ?? "") else { return }
        switch id {
        case .sound:
            userSettings.toggleSound()
            let asset: Asset = userSettings.isSoundEnabled ? .icUnmute : .icMute
            let spriteNode = node as! SKSpriteNode
            spriteNode.texture = SKTexture(imageNamed: asset.rawValue)
        case .rate:
            sceneDelegate?.scene(self, didTapRateNode: node)
        case .mode:
            userSettings.toggleMode()
        case .tutorial:
            self.presentTutorial()
        default:
            break
        }
    }
    
    // MARK: - Helpers
    func updateMode() {
        ball.setColor()
        self.backgroundColor = userSettings.selectedColor
                
        let identifiers: [Identifier] = [.score, .bestScore, .currentScore]
        identifiers.compactMap { (identifier) -> SKLabelNode? in
            return childNode(withName: identifier.rawValue) as? SKLabelNode
        }.forEach { (label) in
            label.fontColor = userSettings.currentMode.inverseColor()
        }
    }
    
    private func removeLives() {
        self.liveNodes.forEach { $0.removeFromParent() }
        self.liveNodes = []
    }
    
    private func speedUpGame() {
        if state.currentState is PlayingState {
            blockManager.setDuration()
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
