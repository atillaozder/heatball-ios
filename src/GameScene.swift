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
let fontName: String = UIFont.systemFont(ofSize: 1).fontName // "Chalkduster"

protocol GameSceneDelegate: class {
    func scene(_ scene: GameScene, didOverGame gameOver: Bool)
    func scene(_ scene: GameScene, didCreateNewScene newScene: GameScene)
    func scene(_ scene: GameScene, didTapRate rate: Bool)
}

class GameScene: SKScene {
    
    let blipSound = SKAction.playSoundFileNamed("pongBlip", waitForCompletion: false)
    weak var gameDelegate: GameSceneDelegate?
    
    lazy var gameState: GKStateMachine = GKStateMachine(
        states: [
            WaitingForTap(scene: self),
            Settings(scene: self),
            Playing(scene: self),
            GameOver(scene: self)
    ])
    
    lazy var ball: SKShapeNode = {
        let radius: CGFloat = 25 / 2
        let ball = SKShapeNode(circleOfRadius: radius)
        ball.name = Identifier.ball.rawValue
        ball.zPosition = 1
        ball.lineWidth = 1
        ball.lineCap = .round
        ball.lineJoin = .round
        
        let body = SKPhysicsBody(circleOfRadius: radius)
        body.friction = 0
        body.angularDamping = 0
        body.linearDamping = 0
        body.restitution = 1
        body.allowsRotation = false
        body.isDynamic = true
        body.affectedByGravity = true
        body.contactTestBitMask = body.collisionBitMask
        body.velocity = velocity
        
        ball.physicsBody = body
        return ball
    }()
    
    lazy var scoreLabel: SKLabelNode = {
        let lbl = SKLabelNode(fontNamed: fontName)
        lbl.fontSize = 24
        lbl.horizontalAlignmentMode = .right
        lbl.verticalAlignmentMode = .top
        lbl.position = CGPoint(x: size.width - 16, y: size.height - 16)
        lbl.zPosition = 1
        lbl.text = "0"
        if #available(iOS 11.0, *) {
            lbl.numberOfLines = 1
        }
        return lbl
    }()
    
    var velocity: CGVector = .init(dx: 300, dy: 300) {
        didSet {
            ball.physicsBody!.velocity = velocity
        }
    }
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    private var heatOfBall = 0 {
        didSet {
            if gameState.currentState is Playing {
                if heatOfBall > 0 {
                    guard let tone = RedTones(rawValue: heatOfBall) else {
                        gameState.enter(GameOver.self)
                        return
                    }
                    
                    ball.fillColor = tone.asColor()
                    ball.strokeColor = tone.asColor()
                    self.decreaseDurationAndIncreaseVelocity()
                    
                    if tone == .red8 {
                        gameState.enter(GameOver.self)
                    }
                }
            }
        }
    }
    
    private var barriers = Set<SKShapeNode>()
    private var duration: TimeInterval = 1.0
    private var lastPositionOfTheBall = CGPoint.zero
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.setTheme()
        self.physicsWorld.contactDelegate = self
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        borderBody.restitution = 1
        borderBody.angularDamping = 0
        borderBody.linearDamping = 0
        self.physicsBody = borderBody
        self.physicsWorld.gravity = .zero
        
        self.addChild(ball)
        gameState.enter(WaitingForTap.self)
        
        addObstaclesSequence()
        run(.repeatForever(.sequence([
            .wait(forDuration: 60),
            .run(decreaseDurationAndIncreaseVelocity)
        ])))
        
        run(.repeatForever(.sequence([
            .wait(forDuration: 2),
            .run(setBallLastPosition)
        ])))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        switch gameState.currentState {
        case is WaitingForTap:
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name == Identifier.settings.rawValue {
                gameState.enter(Settings.self)
            } else if node.name == Identifier.play.rawValue {
                gameState.enter(Playing.self)
            }
        case is GameOver:
            let newScene = GameScene(size: frame.size)
            gameDelegate?.scene(self, didCreateNewScene: newScene)
            newScene.scaleMode = UIDevice.current.userInterfaceIdiom == .pad ? .aspectFit : .aspectFill
            self.view?.presentScene(newScene)
        case is Settings:
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name == Identifier.settings.rawValue {
                gameState.enter(WaitingForTap.self)
            } else if node.name == Identifier.play.rawValue {
                gameState.enter(WaitingForTap.self)
                gameState.enter(Playing.self)
            } else {
                nodeTapped(node)
            }
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if gameState.currentState is Playing {
            guard let touch = touches.first else { return }
            removeBarrier(at: touch.location(in: self))
        }
    }
    
    func nodeTapped(_ node: SKNode) {
        if let name = node.name, let identifier = Identifier(rawValue: name) {
            switch identifier {
            case .sound:
                UserSettings.toggleSound()
                let asset: Asset = UserSettings.soundEnabled ? .icSoundEnabled : .icSoundDisabled
                let spriteNode = node as! SKSpriteNode
                spriteNode.texture = SKTexture(imageNamed: asset.rawValue)
            case .rateUs:
                gameDelegate?.scene(self, didTapRate: true)
            case .theme:
                UserSettings.toggleTheme()
            case .info:
                let scene = TutorialScene(size: frame.size)
                scene.gameDelegate = gameDelegate
                scene.scaleMode = UIDevice.current.userInterfaceIdiom == .pad ? .aspectFit : .aspectFill
                self.view?.presentScene(scene)
            default:
                break
            }
        }
    }
    
    func setTheme() {
        let theme = UserSettings.theme
        self.setBallColor()
        self.backgroundColor = theme.asColor()
        scoreLabel.fontColor = theme.inverseColor()

        let identifiers: [Identifier] = [.score, .bestScore]
        identifiers.forEach { (identifier) in
            if let lbl = childNode(withName: identifier.rawValue) as? SKLabelNode {
                lbl.fontColor = theme.inverseColor()
            }
        }
    }
    
    func startGame() {
        score = 0
        resetGame()
        scoreLabel.removeFromParent()
        addChild(scoreLabel)
        
        ball.removeFromParent()
        addChild(ball)
    }
    
    func gameOver() {
        gameCount += 1
        if gameCount.truncatingRemainder(dividingBy: 2) == 0 {
            gameDelegate?.scene(self, didOverGame: true)
        }
        UserSettings.setHighestScore(score)
        resetGame()
        gameState.enter(WaitingForTap.self)
    }
        
    private func decreaseDurationAndIncreaseVelocity() {
        if gameState.currentState is Playing {
            let newDuration = duration - 0.1
            duration = max(newDuration, 0.5)
            addObstaclesSequence()
            self.velocity = CGVector(dx: velocity.dx + 15, dy: velocity.dy + 15)
        }
    }
    
    private func addObstaclesSequence() {
        let key = "add_barrier_action_key"
        self.removeAction(forKey: key)
        let action = SKAction.sequence([
            .wait(forDuration: duration),
            .run(addBarrier)
        ])
        run(.repeatForever(action), withKey: key)
    }
    
    private func resetGame() {
        heatOfBall = 0
        duration = 1.0
        removeAllBarriers()
        resetBall()
        addObstaclesSequence()
    }
    
    private func resetBall() {
        ball.position = .zero
        self.setBallColor()
        self.velocity = .init(dx: 300, dy: 300)
    }
    
    private func setBallColor() {
        ball.fillColor = UserSettings.theme.inverseColor()
        ball.strokeColor = UserSettings.theme.inverseColor()
    }
    
    private func setBallLastPosition() {
        if ball.position.x == lastPositionOfTheBall.x {
            let pos = SKAction.moveTo(x: ball.position.x + 1, duration: 0.1)
            ball.run(pos)
        }
        
        if ball.position.y == lastPositionOfTheBall.y {
            let pos = SKAction.moveTo(y: ball.position.y + 1, duration: 0.1)
            ball.run(pos)
        }
        
        lastPositionOfTheBall = ball.position
    }

    private func increaseHeat() {
        if gameState.currentState is Playing {
            heatOfBall += 1
            
            if UserSettings.soundEnabled {
                run(blipSound)
            }
        }
    }
}

// MARK: SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if nodeA?.name == Identifier.barrier.rawValue {
            increaseHeat()
            removeBarrier(nodeA as! SKShapeNode)
            return
        }
        
        if nodeB?.name == Identifier.barrier.rawValue {
            increaseHeat()
            removeBarrier(nodeB as! SKShapeNode)
            return
        }
    }
}

// MARK: Obstacles Management
extension GameScene {
    private func addBarrier() {
        let newBarrier = BarrierFactory().generateBarrier()
        if newBarrier.fillColor == UserSettings.theme.asColor() {
            return
        }
        
        let extendedArea = self.ball.frame.insetBy(dx: -20, dy: -20)
        var newPosition = self.generateRandomPosition(barrierSize: newBarrier.frame.size)
        
        // Position should not be near of current game ball
        while extendedArea.contains(newPosition) {
            newPosition = self.generateRandomPosition(barrierSize: newBarrier.frame.size)
        }
        
        newBarrier.position = newPosition
        for barrier in self.barriers {
            if barrier.intersects(newBarrier) {
                return
            }
        }
        
        newBarrier.setScale(0)
        self.addChild(newBarrier)
        newBarrier.run(.scale(to: 1, duration: 0.05))
        self.barriers.insert(newBarrier)
    }
    
    private func removeBarrier(_ barrier: SKShapeNode) {
        barrier.physicsBody!.categoryBitMask = 0x0
        let fade = SKAction.fadeAlpha(to: 0, duration: 0.05)
        barrier.run(fade) { [weak self] in
            barrier.removeFromParent()
            guard let `self` = self else { return }
            self.barriers.remove(barrier)
        }
    }
    
    private func removeBarrier(at location: CGPoint) {
        for barrier in barriers {
            let tappableArea = barrier.frame.insetBy(dx: -15, dy: -15)
            if tappableArea.contains(location) {
                self.score += 1
                self.removeBarrier(barrier)
                break
            }
        }
    }
    
    private func removeAllBarriers() {
        scoreLabel.removeFromParent()
        barriers.forEach { $0.removeFromParent() }
        barriers = Set()
    }
    
    private func generateRandomPosition(barrierSize: CGSize) -> CGPoint {
        var xPos = CGFloat(Float(arc4random()) / Float(UInt32.max)) * size.width
        var yPos = CGFloat(Float(arc4random()) / Float(UInt32.max)) * size.height
        
        if xPos < frame.midX {
            xPos += barrierSize.width
        } else if xPos > frame.midX {
            xPos -= barrierSize.width
        }
        
        if yPos < frame.midY {
            yPos += barrierSize.height
        } else if yPos > frame.midY {
            yPos -= barrierSize.height
        }
        
        return CGPoint(x: xPos, y: yPos)
    }
}
