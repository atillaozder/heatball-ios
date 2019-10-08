//
//  TutorialScene.swift
//  HeatBall
//
//  Created by Atilla Özder on 6.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit
import GameplayKit

class TutorialScene: Scene {
        
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupScene()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)
        switch node.name {
        case Identifier.nextLabel.rawValue,
             Identifier.nextButton.rawValue:
            nextTapped()
        default:
            touchesEnd(at: location)
        }
    }
    
    func setupScene() {
        backgroundColor = userSettings.currentTheme.asColor()
        presentNextButton()
        presentDescription()
    }
    
    func presentNextButton() {
        let (button, label) = SKNode.generateButton(withText: "Next")
        button.position = CGPoint(x: frame.midX, y: frame.minY + 60)
        button.name = Identifier.nextButton.rawValue
        label.position = CGPoint(x: frame.midX, y: frame.minY + 52)
        label.name = Identifier.nextLabel.rawValue
        addChild(label)
        addChild(button)
    }
    
    func presentDescription() {}
    
    func touchesEnd(at location: CGPoint) {}
    
    func nextTapped() {}
}
