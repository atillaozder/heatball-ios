//
//  LiveCircle.swift
//  HeatBall
//
//  Created by Atilla Özder on 7.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

class LiveCircle: Circle {
    
    static var diameter: CGFloat {
        return radius * 2
    }
    
    static var radius: CGFloat = 5
    
    var position: CGPoint {
        get { return shapeNode.position }
        set { shapeNode.position = newValue }
    }
    
    convenience init(origin: CGPoint) {
        self.init(radius: 5)
        self.position = origin
        let color = userSettings.currentTheme.inverseColor()
        shapeNode.fillColor = color
        shapeNode.strokeColor = color
        shapeNode.zPosition = -1
        shapeNode.name = Identifier.liveCircle.rawValue
        shapeNode.physicsBody!.categoryBitMask = 0x0
    }
}
