//
//  RewardState.swift
//  HeatBall
//
//  Created by Atilla Özder on 7.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit
import GameplayKit

// MARK: - RewardState
final class RewardState: GKState {
    
    private var childNodes: [SKNode] = []
    weak var scene: GameScene!
    
    // MARK: - Constructor
    init(scene: SKScene) {
        self.scene = scene as? GameScene
        super.init()
    }
    
    // MARK: - State Life Cycle
    override func didEnter(from previousState: GKState?) {
        if previousState is PlayingState {
            setupState()
            scene.pauseGame()
        }
    }
    
    override func willExit(to nextState: GKState) {
        removeChildNodes()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOverState.Type || stateClass is PlayingState.Type
    }
    
    private func setupState() {
        let factory = SKViewFactory()
        let (nBtn, nLbl) = factory.buildButton(text: "New Game")
        let x = scene.frame.midX
        let nBtnY = scene.frame.midY + 25
        
        nBtn.position = CGPoint(x: x, y: nBtnY)
        nBtn.name = factory.newGameBtn
        nLbl.position = CGPoint(x: x, y: nBtnY - 8)
        nLbl.name = factory.newGameLbl
        
        let (cBtn, cLbl) = factory.buildButton(text: "Continue Game")
        let cBtnY = nBtnY - 50 - 20
        cBtn.position = CGPoint(x: x, y: cBtnY)
        cBtn.name = factory.continueVideoBtn
        cLbl.position = CGPoint(x: x, y: cBtnY - 8)
        cLbl.name = factory.continueVideoLbl
        
        [nBtn, nLbl, cBtn, cLbl].forEach { (node) in
            scene.addChild(node)
            childNodes.append(node)
        }
    }
    
    private func removeChildNodes() {
        childNodes.forEach { $0.removeFromParent() }
        childNodes = []
    }
}
