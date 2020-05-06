//
//  Asset.swift
//  HeatBall
//
//  Created by Atilla Özder on 6.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

// MARK: - Asset
enum Asset: String {
    case icUnmute = "ic_unmute"
    case icMute = "ic_mute"
    case icSettings = "ic_settings"
    case icRate = "ic_rate"
    case icPlay = "ic_play"
    case icTutorial = "ic_tutorial"
    case icHand = "ic_hand"
    
    var asNode: SKSpriteNode {
        return SKSpriteNode(imageNamed: self.rawValue)
    }
}
