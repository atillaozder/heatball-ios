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
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOver.Type
            || stateClass is Playing.Type
    }
    
    private func initialize() {
        let (vButton, vLabel) = SKNode.generateButton(withText: "Watch a Video")
        vButton.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        vButton.name = Identifier.continueWithVideoButton.rawValue
        vLabel.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - 8)
        vLabel.name = Identifier.continueWithVideoLabel.rawValue
        
        let (pButton, pLabel) = SKNode.generateButton(withText: "New Game")
        pButton.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - 60)
        pButton.name = Identifier.playAnotherGameButton.rawValue
        pLabel.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - 68)
        pLabel.name = Identifier.playAnotherGameLabel.rawValue
        
        [pButton, pLabel, vButton, vLabel].forEach { (node) in
            scene.addChild(node)
            childNodes.append(node)
        }
    }
    
    private func removeChildNodes() {
        childNodes.forEach { $0.removeFromParent() }
        childNodes = []
    }
}
