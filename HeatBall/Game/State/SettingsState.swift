//
//  SettingsState.swift
//  HeatBall
//
//  Created by Atilla Özder on 6.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit
import GameplayKit

// MARK: - SettingsState
final class SettingsState: GKState {
    
    weak var scene: GameScene!
    
    static var iconSize: CGSize {
        return .init(width: 50, height: 50)
    }
    
    var spacing: CGFloat {
        return 12
    }
        
    // MARK: - Constructor
    init(scene: SKScene) {
        self.scene = scene as? GameScene
        super.init()
        
        let x = scene.frame.maxX - 40
        let iconSize = SettingsState.iconSize
        
        let asset: Asset = userSettings.isSoundEnabled ? .icUnmute : .icMute
        let soundY = scene.frame.maxY - 40 - iconSize.height - spacing
        addChildNode(at: .init(x: x, y: soundY), asset: asset, withID: .sound)

        let rateY = soundY - iconSize.height - spacing
        addChildNode(at: .init(x: x, y: rateY), asset: .icRate, withID: .rate)
        
        let tutorialY = rateY - iconSize.height - spacing
        addChildNode(at: .init(x: x, y: tutorialY), asset: .icTutorial, withID: .tutorial)
    }
    
    private func addChildNode(
        at position: CGPoint,
        asset: Asset,
        withID identifier: Identifier)
    {
        let node = SKSpriteNode(imageNamed: asset.rawValue)
        node.name = identifier.rawValue
        node.position = position
        node.size = SettingsState.iconSize
        node.zPosition = 1
        node.alpha = 0
        self.scene.addChild(node)
    }
        
    // MARK: - State Life Cycle
    override func didEnter(from previousState: GKState?) {
        if previousState is WaitingToPlayState {
            animChildNodes(.fadeIn(withDuration: 0.1))
        }
    }
    
    override func willExit(to nextState: GKState) {
        if nextState is WaitingToPlayState || nextState is PlayingState {
            animChildNodes(.fadeOut(withDuration: 0.1))
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WaitingToPlayState.Type
    }
    
    private func animChildNodes(_ anim: SKAction) {
        let identifiers: [Identifier] = [.sound, .mode, .rate, .tutorial]
        identifiers.forEach { (identifier) in
            scene?.childNode(withName: identifier.rawValue)?.run(anim)
        }
    }
}
