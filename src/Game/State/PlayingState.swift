//
//  PlayingState.swift
//  HeatBall
//
//  Created by Atilla Özder on 5.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit
import GameplayKit

// MARK: - PlayingState
final class PlayingState: GKState {
    
    weak var scene: GameScene!
    
    // MARK: - Constructor
    init(scene: SKScene) {
        self.scene = scene as? GameScene
        super.init()
    }
        
    // MARK: - State Life Cycle
    override func didEnter(from previousState: GKState?) {
        if previousState is WaitingToPlayState {
            scene.initializeGame()
        } else if previousState is RewardState {
            scene.startGame()
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOverState.Type || stateClass is RewardState.Type
    }
}

