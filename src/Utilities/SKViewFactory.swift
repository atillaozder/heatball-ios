//
//  SKViewFactory.swift
//  HeatBall
//
//  Created by Atilla Özder on 11.03.2020.
//  Copyright © 2020 Atilla Özder. All rights reserved.
//

import SpriteKit

struct SKViewFactory {
    
    let continueVideoBtn = "continueVideoBtn"
    let continueVideoLbl = "continueVideoLbl"
    let newGameBtn = "newGameBtn"
    let newGameLbl = "newGameLbl"

    let fontName = "AmericanTypewriter-semibold"

    func buildLabel(withIdentifier identifier: Identifier? = nil) -> SKLabelNode {
        let lbl = SKLabelNode(fontNamed: fontName)
        lbl.fontSize = 24
        lbl.fontColor = userSettings.currentMode.inverseColor()
        lbl.zPosition = 999
        
        if let id = identifier {
            lbl.name = id.rawValue
        }
        
        return lbl
    }
    
    func buildButton(text: String) -> (button: SKShapeNode, label: SKLabelNode) {
        let color = userSettings.currentMode.inverseColor()

        let label = buildLabel()
        label.fontName = fontName
        label.fontSize = 24
        label.text = text
        label.fontColor = color
        label.zPosition = 999
        
        let shape = SKShapeNode(rectOf: .init(width: 220, height: 50), cornerRadius: 14)
        shape.lineWidth = 4
        shape.strokeColor = color
        shape.fillColor = userSettings.currentMode.asColor()
        shape.zPosition = 999
        
        return (button: shape, label: label)
    }
}
