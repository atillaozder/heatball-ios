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
        let asset: Asset = UserSettings.soundEnabled ? .icSoundEnabled : .icSoundDisabled
        addChildNode(
            at: .init(x: soundPosX, y: posY),
            imageNamed: asset.rawValue,
            withIdentifier: .sound)
        
        let themePosX = soundPosX - Settings.iconSize.width - spacing
        addChildNode(
            at: .init(x: themePosX, y: posY),
            imageNamed: Asset.icTheme.rawValue,
            withIdentifier: .theme)

        let ratePosX = themePosX - Settings.iconSize.width - spacing
        addChildNode(
            at: .init(x: ratePosX, y: posY),
            imageNamed: Asset.icRate.rawValue,
            withIdentifier: .rateUs)
        
        let infoPosX = ratePosX - Settings.iconSize.width - spacing
        addChildNode(
            at: .init(x: infoPosX, y: posY),
            imageNamed: Asset.icInfo.rawValue,
            withIdentifier: .info)
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
    
    private func scaleChildNodes(_ scale: SKAction) {
        let identifiers: [Identifier] = [.sound, .theme, .rateUs, .info]
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
