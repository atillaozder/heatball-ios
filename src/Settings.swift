//
//  Settings.swift
//  HeatBall
//
//  Created by Atilla Özder on 6.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit
import GameplayKit

class Settings: GKState {
    weak var scene: GameScene?
    
    static var iconSize: CGSize {
        return .init(width: 50, height: 50)
    }
    
    var spacing: CGFloat {
        return 12
    }
        
    init(scene: SKScene) {
        self.scene = scene as? GameScene
        super.init()
        self.initialize()
    }
    
    private func initialize() {
        guard let gameScene = self.scene else { return }
        let posY = gameScene.frame.maxY - 40
        
        let soundPosX = gameScene.frame.maxX - 40 - Settings.iconSize.width - spacing
        addChildNode(
            at: .init(x: soundPosX, y: posY),
            imageNamed: PlayerSettings.soundEnabled ? "ic_sound_enabled" : "ic_sound_disabled",
            withIdentifier: .sound)
        
        let themePosX = soundPosX - Settings.iconSize.width - spacing
        addChildNode(
            at: .init(x: themePosX, y: posY),
            imageNamed: "ic_theme",
            withIdentifier: .theme)

        addChildNode(
            at: .init(x: themePosX - Settings.iconSize.width - spacing, y: posY),
            imageNamed: "ic_rate",
            withIdentifier: .rateUs)
    }
    
    func addChildNode(at position: CGPoint,
                      imageNamed: String,
                      withIdentifier identifier: Identifier) {
        let node = SKSpriteNode(imageNamed: imageNamed)
        node.name = identifier.rawValue
        node.position = position
        node.size = Settings.iconSize
        node.zPosition = 1
        node.setScale(0)
        scene?.addChild(node)
    }
        
    override func didEnter(from previousState: GKState?) {
        if previousState is WaitingForTap {
            scaleChildNodes(.scale(to: 1, duration: 0.15))
        }
    }
    
    override func willExit(to nextState: GKState) {
        if nextState is WaitingForTap {
            scaleChildNodes(.scale(to: 0, duration: 0.15))
        }
    }
    
    private func scaleChildNodes(_ scale: SKAction, nextStateIsPlaying: Bool = false) {
        let identifiers: [Identifier] = [.sound, .theme, .rateUs]
        identifiers.forEach { (identifier) in
            scene!
                .childNode(withName: identifier.rawValue)!
                .run(scale)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WaitingForTap.Type
    }
}
