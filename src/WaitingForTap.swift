//
//  WaitingForTap.swift
//  Ball
//
//  Created by Atilla Özder on 5.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit
import GameplayKit

class WaitingForTap: GKState {
    weak var scene: GameScene?
    
    init(scene: SKScene) {
        self.scene = scene as? GameScene
        super.init()
        self.initialize()
    }
    
    private func initialize() {
        guard let gameScene = self.scene else { return }
        let tapToPlay = SKSpriteNode(imageNamed: "ic_tap_to_play")
        tapToPlay.name = Identifier.tapToPlay.rawValue
        tapToPlay.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
        tapToPlay.zPosition = 1
        tapToPlay.setScale(0)
        gameScene.addChild(tapToPlay)
        
        let totalScore = SKLabelNode(fontNamed: FONT_NAME)
        totalScore.fontSize = 24
        totalScore.fontColor = .white
        totalScore.name = Identifier.totalScore.rawValue
        totalScore.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY - 55)
        totalScore.zPosition = 1
        totalScore.setScale(0)
        gameScene.addChild(totalScore)
    }
    
    override func didEnter(from previousState: GKState?) {
        let scale: SKAction = .scale(to: 1, duration: 0.25)
        scene?
            .childNode(withName: Identifier.tapToPlay.rawValue)!
            .run(scale)
        
        let label = scene?.childNode(withName: Identifier.totalScore.rawValue) as! SKLabelNode
        
        if previousState is GameOver {
            label.text = "Ball is heated too much. Score \(scene?.score ?? 0)"
        }
        
        label.run(scale)
    }
    
    override func willExit(to nextState: GKState) {
        if nextState is Playing {
            let scale: SKAction = .scale(to: 0, duration: 0.25)
            scene?
                .childNode(withName: Identifier.tapToPlay.rawValue)!
                .run(scale)
            
            scene?
                .childNode(withName: Identifier.totalScore.rawValue)!
                .run(scale)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Playing.Type
    }
}

