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
    
    weak var scene: GameScene!
    
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
        let posX = gameScene.frame.maxX - 40
        
        let asset: Asset = userSettings.isSoundEnabled ?
            .icSoundEnabled :
            .icSoundDisabled
        
        let soundPosY = gameScene.frame.maxY - 40 - Settings.iconSize.height - spacing
        addChildNode(
            at: .init(x: posX, y: soundPosY),
            imageNamed: asset.rawValue,
            withIdentifier: .sound)
        
        let themePosY = soundPosY - Settings.iconSize.height - spacing
        addChildNode(
            at: .init(x: posX, y: themePosY),
            imageNamed: Asset.icTheme.rawValue,
            withIdentifier: .theme)

        let ratePosY = themePosY - Settings.iconSize.height - spacing
        addChildNode(
            at: .init(x: posX, y: ratePosY),
            imageNamed: Asset.icRate.rawValue,
            withIdentifier: .rateUs)
        
        let tutorialPosY = ratePosY - Settings.iconSize.height - spacing
        addChildNode(
            at: .init(x: posX, y: tutorialPosY),
            imageNamed: Asset.icTutorial.rawValue,
            withIdentifier: .tutorial)
    }
    
    func addChildNode(at position: CGPoint,
                      imageNamed: String,
                      withIdentifier identifier: Identifier) {
        let node = SKSpriteNode(imageNamed: imageNamed)
        node.name = identifier.rawValue
        node.position = position
        node.size = Settings.iconSize
        node.zPosition = 1
        node.alpha = 0
        self.scene.addChild(node)
    }
        
    override func didEnter(from previousState: GKState?) {
        if previousState is WaitingForTap {
            animChildNodes(.fadeIn(withDuration: 0.1))
        }
    }
    
    override func willExit(to nextState: GKState) {
        if nextState is WaitingForTap {
            animChildNodes(.fadeOut(withDuration: 0.1))
        }
    }

    private func animChildNodes(_ anim: SKAction) {
        let identifiers: [Identifier] = [.sound, .theme, .rateUs, .tutorial]
        identifiers.forEach { (identifier) in
            scene!
                .childNode(withName: identifier.rawValue)!
                .run(anim)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WaitingForTap.Type
    }
}
