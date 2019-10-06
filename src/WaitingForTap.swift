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
        let play = Asset.icPlay.asNode
        play.name = Identifier.play.rawValue
        play.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
        play.size = playSize
        play.zPosition = 1
        gameScene.addChild(play)
        
        let settings = Asset.icSettings.asNode
        settings.name = Identifier.settings.rawValue
        settings.position = CGPoint(x: gameScene.frame.maxX - 40, y: gameScene.frame.maxY - 40)
        settings.size = Settings.iconSize
        settings.zPosition = 1
        gameScene.addChild(settings)
        
        let score = generateLabel()
        score.name = Identifier.score.rawValue
        
        let bestScore = generateLabel()
        bestScore.name = Identifier.bestScore.rawValue
        
        let posY = gameScene.frame.midY - playSize.height
        score.position = CGPoint(x: gameScene.frame.midX, y: posY)
        gameScene.addChild(score)
        
        let bestScorePosY = posY - 32
        bestScore.position = CGPoint(x: gameScene.frame.midX, y: bestScorePosY)
        gameScene.addChild(bestScore)
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is GameOver {
            scaleChildNodes(.scale(to: 1, duration: 0.15))
            let scoreLabel = scene?.childNode(withName: Identifier.score.rawValue) as! SKLabelNode
            scoreLabel.text = "Ball overheated. Score: \(scene?.score ?? 0)"

            let highest = UserSettings.highestScore
            if highest > 0 {
                let bestLabel = scene?.childNode(withName: Identifier.bestScore.rawValue) as! SKLabelNode
                bestLabel.text = "Best: \(highest)"
            }
        }
    }
    
    override func willExit(to nextState: GKState) {
        if nextState is Playing {
            scaleChildNodes(.scale(to: 0, duration: 0))
        }
    }
    
    private func generateLabel() -> SKLabelNode {
        let lbl = SKLabelNode(fontNamed: fontName)
        lbl.fontSize = 24
        lbl.fontColor = UserSettings.theme.inverseColor()
        lbl.zPosition = 1
        return lbl
    }
    
    func scaleChildNodes(_ scale: SKAction) {
        let identifiers: [Identifier] = [.play, .settings, .score, .bestScore]
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

