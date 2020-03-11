//
//  Scene.swift
//  HeatBall
//
//  Created by Atilla Özder on 8.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

protocol SceneDelegate: class {
    func scene(_ scene: GameScene, shouldPresentRewardBasedVideoAd present: Bool)
    func scene(_ scene: GameScene, shouldPresentInterstitial present: Bool)
    func scene(_ scene: GameScene, didCreateNewScene newScene: GameScene)
    func scene(_ scene: GameScene, didTapRateNode node: SKNode)
}

class Scene: SKScene {
    
    let sound = SKAction.playSoundFileNamed("pong", waitForCompletion: false)
    weak var sceneDelegate: SceneDelegate?
    
    var insets: UIEdgeInsets = .zero {
        didSet {
            didChangeSafeArea()
        }
    }
    
    func presentTutorial() {
        let scene = TutorialScene(size: frame.size)
        scene.sceneDelegate = sceneDelegate
        scene.insets = insets
        scene.scaleMode = UIDevice.current.scaleMode
        self.view?.presentScene(scene)
    }
    
    func didChangeSafeArea() {
        return
    }
}
