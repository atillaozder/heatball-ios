//
//  GameScene.swift
//  Ball
//
//  Created by Atilla Özder on 5.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit
import GameplayKit

/// TODO
// music & ayarlar & tutorial & darkMode
// bugta kalıyor bazen top
// change debug profile

let FONT_NAME: String = "Chalkduster"

enum Identifier: String {
    case ball = "ball"
    case barrier = "barrier"
    case tapToPlay = "tap_to_play"
    case totalScore = "total_score"
}

protocol GameSceneDelegate: class {
    func scene(_ scene: GameScene, didOverGame gameOver: Bool)
    func scene(_ scene: GameScene, didCreateNewScene newScene: GameScene)
}

class GameScene: SKScene {
    
    static var gameCount: Double = 0
    weak var gameDelegate: GameSceneDelegate?
    
    lazy var gameState: GKStateMachine = GKStateMachine(
        states: [
            WaitingForTap(scene: self),
            Playing(scene: self),
            GameOver(scene: self)
    ])
    
    lazy var ball: SKShapeNode = {
        let radius: CGFloat = 25 / 2
        let ball = SKShapeNode(circleOfRadius: radius)
        ball.name = Identifier.ball.rawValue
        ball.zPosition = 1
        ball.fillColor = .white
        ball.strokeColor = .white
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
    
    private let barrierFactory = BarrierFactory()
    private var barriers = Set<SKShapeNode>()
    private var duration: TimeInterval = 1.0
    
    lazy var scoreLabel: SKLabelNode = {
        let lbl = SKLabelNode(fontNamed: FONT_NAME)
        lbl.fontColor = .white
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
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.backgroundColor = .dark
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

        setRepeatAction()
        run(.repeatForever(.sequence([
            .wait(forDuration: 60),
            .run(decreaseDurationAndIncreaseVelocity)
        ])))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        switch gameState.currentState {
        case is WaitingForTap:
            gameState.enter(Playing.self)
        case is Playing:
            break
        case is GameOver:
            let newScene = GameScene(fileNamed: "GameScene")!
            gameDelegate?.scene(self, didCreateNewScene: newScene)
            newScene.scaleMode = .aspectFill
            self.view?.presentScene(newScene)
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

    func decreaseDurationAndIncreaseVelocity() {
        if gameState.currentState is Playing {
            let newDuration = duration - 0.1
            duration = max(newDuration, 0.5)
            setRepeatAction()
            self.velocity = CGVector(dx: velocity.dx + 15, dy: velocity.dy + 15)
        }
    }
    
    func setRepeatAction() {
        let key = "add_barrier_action"
        self.removeAction(forKey: key)
        let action = SKAction.sequence([
            .wait(forDuration: duration),
            .run(addBarrier)
        ])
        run(.repeatForever(action), withKey: key)
    }
    
    func resetGame() {
        heatOfBall = 0
        duration = 1.0
        removeAllBarriers()
        resetBall()
        setRepeatAction()
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
        GameScene.gameCount += 1
        if GameScene.gameCount.truncatingRemainder(dividingBy: 2) == 0 {
            gameDelegate?.scene(self, didOverGame: true)
        }
        
        resetGame()
        gameState.enter(WaitingForTap.self)
    }
    
    private func increaseHeat() {
        if gameState.currentState is Playing {
            heatOfBall += 1
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if nodeA?.name == Identifier.barrier.rawValue {
            increaseHeat()
            removeBarrier(nodeA as! SKShapeNode)
        }
        
        if nodeB?.name == Identifier.barrier.rawValue {
            increaseHeat()
            removeBarrier(nodeB as! SKShapeNode)
        }
    }
}

// MARK: Barrier Management
extension GameScene {
    private func addBarrier() {
        guard let newBarrier = barrierFactory.generateBarrier() else { return }
        let extendedArea = self.ball.frame.insetBy(dx: -20, dy: -20)
        var newPosition = self.generateRandomPosition(barrierSize: newBarrier.frame.size)
        
        // Position should not be near of current game ball
        while extendedArea.contains(newPosition) {
            newPosition = self.generateRandomPosition(barrierSize: newBarrier.frame.size)
        }
        
        newBarrier.position = newPosition
        newBarrier.zPosition = 1
        
        for barrier in self.barriers {
            if barrier.intersects(newBarrier) {
                return
            }
        }
        
        self.addChild(newBarrier)
        self.barriers.insert(newBarrier)
    }
    
    private func removeBarrier(_ barrier: SKShapeNode) {
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
        for barrier in barriers {
            barrier.removeFromParent()
        }
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

// MARK: Ball Management
extension GameScene {
    func resetBall() {
        ball.position = .zero
        ball.fillColor = .white
        ball.strokeColor = .white
        resetVelocity()
    }

    private func resetVelocity() {
        self.velocity = .init(dx: 300, dy: 300)
        ball.physicsBody!.velocity = self.velocity
    }
}
