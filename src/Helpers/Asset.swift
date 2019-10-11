//
//  Asset.swift
//  HeatBall
//
//  Created by Atilla Özder on 6.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import SpriteKit

enum Asset: String {
    case icSoundEnabled = "ic_sound_enabled"
    case icSoundDisabled = "ic_sound_disabled"
    case icTheme = "ic_theme"
    case icSettings = "ic_settings"
    case icRate = "ic_rate"
    case icPlay = "ic_play"
    case icWhiteHand = "ic_white_hand"
    case icBlackHand = "ic_black_hand"
    case icTutorial = "ic_tutorial"
    case icWhiteArrow = "ic_white_arrow"
    case icBlackArrow = "ic_black_arrow"
    
    var asNode: SKSpriteNode {
        return SKSpriteNode(imageNamed: self.rawValue)
    }
}
