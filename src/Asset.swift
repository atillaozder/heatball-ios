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
    case icFingerBlack = "ic_finger_black"
    case icFingerWhite = "ic_finger_white"
    case icInfo = "ic_info"
    
    var asNode: SKSpriteNode {
        return SKSpriteNode(imageNamed: self.rawValue)
    }
}
