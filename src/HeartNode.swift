//
//  HeartNode.swift
//  HeatBall
//
//  Created by Atilla Özder on 7.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

class HeartNode: SKShapeNode {
    
    static var nodeSize: CGSize {
        return CGSize(width: 8, height: 16)
    }
    
    convenience init(origin: CGPoint) {
        self.init(rect: .init(origin: origin, size: HeartNode.nodeSize), cornerRadius: 3)
        setup()
    }
    
    private func setup() {
        self.fillColor = .green
        self.strokeColor = .green
        self.zPosition = 999
    }
}
