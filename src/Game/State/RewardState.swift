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
        let (btn, lbl) = factory.buildButton(text: "New Game")
        let x = scene.frame.midX
        let btnY = scene.frame.midY + 25
        
        btn.position = CGPoint(x: x, y: btnY)
        btn.name = factory.newGameBtn
        lbl.position = CGPoint(x: x, y: btnY - 8)
        lbl.name = factory.newGameLbl
        
        var text = "View this ad"
        if #available(iOS 11.0, *) {
            text = "View this ad to continue game"
        }
        
        let (videoBtn, videoLbl) = factory.buildButton(text: text, height: 80)
        let videoBtnY = btnY - 50 - 32
        videoBtn.position = CGPoint(x: x, y: videoBtnY)
        videoBtn.name = factory.continueVideoBtn
        videoLbl.name = factory.continueVideoLbl

        var childs = [btn, lbl, videoBtn, videoLbl]
        
        var videoLblY = videoBtnY + 8
        if #available(iOS 11.0, *) {
            videoLblY = videoBtnY - 28
            videoLbl.numberOfLines = 3
            videoLbl.lineBreakMode = .byWordWrapping
            videoLbl.preferredMaxLayoutWidth = 220
        } else {
            let remainingTextLabel = videoLbl.copy() as! SKLabelNode
            remainingTextLabel.name = factory.iOS10ContinueVideoLbl
            remainingTextLabel.text = "to continue game"
            remainingTextLabel.position = CGPoint(x: x, y: videoLblY - 28)
            childs.append(remainingTextLabel)
        }
        
        videoLbl.position = CGPoint(x: x, y: videoLblY)
                        
        childs.forEach { (node) in
            scene.addChild(node)
            childNodes.append(node)
        }
    }
    
    private func removeChildNodes() {
        childNodes.forEach { $0.removeFromParent() }
        childNodes = []
    }
}
