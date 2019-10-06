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
        let playSize = CGSize(width: 75, height: 75)
        let play = SKSpriteNode(imageNamed: "ic_play")
        play.name = Identifier.play.rawValue
        play.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
        play.size = playSize
        play.zPosition = 1
        gameScene.addChild(play)
        
        let settings = SKSpriteNode(imageNamed: "ic_settings")
        settings.name = Identifier.settings.rawValue
        settings.position = CGPoint(x: gameScene.frame.maxX - 40, y: gameScene.frame.maxY - 40)
        settings.size = Settings.iconSize
        settings.zPosition = 1
        gameScene.addChild(settings)
        
        let score = SKLabelNode(fontNamed: GameScene.fontName)
        score.fontSize = 24
        score.fontColor = PlayerSettings.theme.inverseColor()
        score.name = Identifier.totalScore.rawValue
        score.zPosition = 1
        
        let posY = gameScene.frame.midY - playSize.height
        score.position = CGPoint(x: gameScene.frame.midX, y: posY)

        gameScene.addChild(score)
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is GameOver {
            scaleChildNodes(.scale(to: 1, duration: 0.15))
            let lbl = scene?.childNode(withName: Identifier.totalScore.rawValue) as! SKLabelNode
            lbl.text = "Ball overheated. Score \(scene?.score ?? 0)"
        }
    }
    
    override func willExit(to nextState: GKState) {
        if nextState is Playing {
            scaleChildNodes(.scale(to: 0, duration: 0))
        }
    }
    
    func scaleChildNodes(_ scale: SKAction) {
        let identifiers: [Identifier] = [.play, .settings, .totalScore]
        identifiers.forEach { (identifier) in
            scene!
                .childNode(withName: identifier.rawValue)!
                .run(scale)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Playing.Type || stateClass is Settings.Type
    }
}

