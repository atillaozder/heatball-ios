//
//  BarrierFactory.swift
//  Ball
//
//  Created by Atilla Özder on 5.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

struct BarrierFactory {

    func generateBarrier() -> SKShapeNode? {
        let fillColor: UIColor = .random
        if fillColor == .dark {
            return nil
        }
        
        let diameter: CGFloat = .random(in: 10...35)
        let radius = diameter / 2
        
        let barrier = SKShapeNode(circleOfRadius: radius)
        barrier.name = Identifier.barrier.rawValue
        barrier.zPosition = 1
        barrier.fillColor = fillColor
        barrier.strokeColor = fillColor
        barrier.lineWidth = 1
        barrier.lineJoin = .round
        barrier.lineCap = .round
        
        let body = SKPhysicsBody(circleOfRadius: radius)
        body.friction = 0
        body.angularDamping = 0
        body.linearDamping = 0
        body.restitution = 1
        body.allowsRotation = false
        body.isDynamic = false
        body.affectedByGravity = false
        //        body.categoryBitMask = 0x0
        
        barrier.physicsBody = body
        return barrier
    }
}
