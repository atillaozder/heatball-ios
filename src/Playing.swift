//
//  Playing.swift
//  Ball
//
//  Created by Atilla Özder on 5.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit
import GameplayKit

class Playing: GKState {
    
    weak var scene: GameScene!
    
    init(scene: SKScene) {
        self.scene = scene as? GameScene
        super.init()
    }
        
    override func didEnter(from previousState: GKState?) {
        if previousState is WaitingForTap {
            scene.initializeGame()
        } else if previousState is Reward {
            scene.startGame()
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOver.Type
            || stateClass is Reward.Type
    }
}

