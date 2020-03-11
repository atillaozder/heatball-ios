//
//  GameOverState.swift
//  HeatBall
//
//  Created by Atilla Özder on 5.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit
import GameplayKit

// MARK: - GameOverState
final class GameOverState: GKState {
    
    weak var scene: GameScene!
    
    // MARK: - Constructor
    init(scene: SKScene) {
        self.scene = scene as? GameScene
        super.init()
    }
    
    // MARK: - State Life Cycle
    override func didEnter(from previousState: GKState?) {
        if previousState is PlayingState || previousState is RewardState {
            scene.endGame()
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WaitingToPlayState.Type
    }
}
