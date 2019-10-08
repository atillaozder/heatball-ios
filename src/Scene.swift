//
//  Scene.swift
//  HeatBall
//
//  Created by Atilla Özder on 8.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

class Scene: SKScene {
    weak var sceneDelegate: SceneDelegate?
    
    var safeAreaInsets: UIEdgeInsets = .zero {
        didSet {
            didChangeSafeArea()
        }
    }
    
    func presentTutorial(_ scene: TutorialScene, delegate: SceneDelegate?) {
        scene.sceneDelegate = delegate
        scene.safeAreaInsets = safeAreaInsets
        scene.scaleMode = UIDevice.current.scaleMode
        self.view?.presentScene(scene)
    }
    
    func didChangeSafeArea() {
        return
    }
}
