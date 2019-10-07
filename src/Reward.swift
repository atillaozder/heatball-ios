//
//  Reward.swift
//  HeatBall
//
//  Created by Atilla Özder on 7.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit
import GameplayKit

class Reward: GKState {
    
    private var childNodes: [SKNode] = []
    weak var scene: GameScene!
    
    init(scene: SKScene) {
        self.scene = scene as? GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is Playing {
            initialize()
            scene.pauseGame()
        }
    }
    
    override func willExit(to nextState: GKState) {
        removeChildNodes()
        if nextState is Playing {
            scene.continueGame()
        } else if nextState is GameOver {
            scene.gameOver()
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOver.Type
            || stateClass is Playing.Type
    }
    
    private func initialize() {
        addButton(toYAxis: (labelY: 24, buttonY: 32),
                  withText: "Continue game with watching a video",
                  andIdentifier: .continueWithVideo)
        
        addButton(toYAxis: (labelY: -40, buttonY: -32),
                  withText: "Play another game",
                  andIdentifier: .gameOver)
    }
    
    private func addButton(toYAxis yAxis: (labelY: CGFloat, buttonY: CGFloat),
                           withText text: String,
                           andIdentifier id: Identifier) {
        let color = userSettings.currentTheme.inverseColor()
        let lbl = SKLabelNode.defaultLabel
        let font = UIFont.systemFont(ofSize: 20, weight: .medium)
        lbl.fontName = font.fontName
        lbl.text = text
        lbl.fontColor = color
        lbl.name = id.rawValue
        lbl.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY + yAxis.labelY)
        lbl.zPosition = 999

        let shape = SKShapeNode(rectOf: .init(width: 390, height: 44), cornerRadius: 14)
        shape.position = .init(x: scene.frame.midX, y: scene.frame.midY + yAxis.buttonY)
        shape.strokeColor = color
        shape.fillColor = userSettings.currentTheme.asColor()
        shape.name = id.rawValue
        shape.zPosition = 999
        
        scene.addChild(lbl)
        scene.addChild(shape)
        
        childNodes.append(lbl)
        childNodes.append(shape)
    }
    
    private func removeChildNodes() {
        childNodes.forEach { $0.removeFromParent() }
        childNodes = []
    }
}
