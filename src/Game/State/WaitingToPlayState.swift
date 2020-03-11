//
//  WaitingToPlayState.swift
//  HeatBall
//
//  Created by Atilla Özder on 5.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit
import GameplayKit

// MARK: - WaitingToPlayState
final class WaitingToPlayState: GKState {
    
    weak var scene: GameScene!
    
    // MARK: - Constructor
    init(scene: SKScene) {
        self.scene = scene as? GameScene
        super.init()
        
        let iconSize = CGSize(width: 75, height: 75)
        setupPlayButton(size: iconSize)
        setupSettingsButton()
                    
        let scoreLabel = SKViewFactory().buildLabel(withIdentifier: .score)
        let scoreY = scene.frame.midY - iconSize.height
        scoreLabel.position = CGPoint(x: scene.frame.midX, y: scoreY)
        scene.addChild(scoreLabel)
        
        let bestScoreLabel = SKViewFactory().buildLabel(withIdentifier: .bestScore)
        bestScoreLabel.position = CGPoint(x: scene.frame.midX, y: scoreY - 32)
        scene.addChild(bestScoreLabel)
    }
    
    // MARK: - View Initialization
    private func setupPlayButton(size: CGSize) {
        guard let scene = self.scene else { return }
        let node = Asset.icPlay.asNode
        node.name = Identifier.play.rawValue
        node.size = size
        node.zPosition = 1
        node.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        scene.addChild(node)
    }
    
    private func setupSettingsButton() {
        guard let scene = self.scene else { return }
        let node = Asset.icSettings.asNode
        node.name = Identifier.settings.rawValue
        node.position = CGPoint(x: scene.frame.maxX - 40, y: scene.frame.maxY - 40)
        node.size = SettingsState.iconSize
        node.zPosition = 1
        scene.addChild(node)
    }

    // MARK: - Game Life Cycle
    override func didEnter(from previousState: GKState?) {
        if previousState is GameOverState {
            setChildNodes(isHidden: false)
            let scoreLabel = scene.childNode(withIdentifier: .score) as! SKLabelNode
            scoreLabel.text = "Score: \(scene.score)"

            let bestScore = userSettings.bestScore
            if bestScore > 0 {
                let bestScoreLabel = scene.childNode(withIdentifier: .bestScore) as! SKLabelNode
                bestScoreLabel.text = "Best: \(bestScore)"
            }
        }
    }
    
    override func willExit(to nextState: GKState) {
        if nextState is PlayingState {
            setChildNodes(isHidden: true)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayingState.Type || stateClass is SettingsState.Type
    }
        
    private func setChildNodes(isHidden: Bool) {
        let identifiers: [Identifier] = [.play, .settings, .score, .bestScore]
        identifiers.forEach { (identifier) in
            scene?.childNode(withName: identifier.rawValue)?.isHidden = isHidden
        }
    }
}

