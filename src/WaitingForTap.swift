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
    
    weak var scene: GameScene!
    
    init(scene: SKScene) {
        self.scene = scene as? GameScene
        super.init()
        self.initialize()
    }

    override func didEnter(from previousState: GKState?) {
        if previousState is GameOver {
            setChildNodes(isHidden: false)
            let totalScore = scene.childNode(withIdentifier: .totalScore) as! SKLabelNode
            totalScore.text = "Ball overheated. Score: \(scene.score)"

            let highestScore = userSettings.highestScore
            if highestScore > 0 {
                let bestScore = scene.childNode(withIdentifier: .bestScore) as! SKLabelNode
                bestScore.text = "Best: \(highestScore)"
            }
        }
    }
    
    override func willExit(to nextState: GKState) {
        if nextState is Playing {
            setChildNodes(isHidden: true)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Playing.Type || stateClass is Settings.Type
    }
    
    private func initialize() {
        let playSize = CGSize(width: 75, height: 75)
        setupPlayButton(size: playSize)
        setupSettingsButton()
        
        guard let gameScene = scene else { return }
        let totalScore = SKLabelNode.defaultLabel
        totalScore.name = Identifier.totalScore.rawValue
    
        let bestScore = SKLabelNode.defaultLabel
        bestScore.name = Identifier.bestScore.rawValue
        
        let totalScorePosY = gameScene.frame.midY - playSize.height
        totalScore.position = CGPoint(
            x: gameScene.frame.midX,
            y: totalScorePosY)
        gameScene.addChild(totalScore)
        
        let bestScorePosY = totalScorePosY - 32
        bestScore.position = CGPoint(
            x: gameScene.frame.midX,
            y: bestScorePosY)
        gameScene.addChild(bestScore)
    }
    
    private func setupPlayButton(size: CGSize) {
        guard let gameScene = self.scene else { return }
        let node = Asset.icPlay.asNode
        node.name = Identifier.play.rawValue
        node.size = size
        node.zPosition = 1
        node.position = CGPoint(
            x: gameScene.frame.midX,
            y: gameScene.frame.midY)
        gameScene.addChild(node)
    }
    
    private func setupSettingsButton() {
        guard let gameScene = self.scene else { return }
        let node = Asset.icSettings.asNode
        node.name = Identifier.settings.rawValue
        node.position = CGPoint(
            x: gameScene.frame.maxX - 40,
            y: gameScene.frame.maxY - 40)
        node.size = Settings.iconSize
        node.zPosition = 1
        gameScene.addChild(node)
    }
    
    func setChildNodes(isHidden: Bool) {
        let identifiers: [Identifier] = [.play, .settings, .totalScore, .bestScore]
        identifiers.forEach { (identifier) in
            scene!
                .childNode(withName: identifier.rawValue)!
                .isHidden = isHidden
        }
    }
}

