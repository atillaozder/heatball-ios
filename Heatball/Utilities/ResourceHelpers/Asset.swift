//
//  Asset.swift
//  HeatBall
//
//  Created by Atilla Özder on 25.09.2020.
//  Copyright © 2020 Atilla Özder. All rights reserved.
//

import UIKit

// MARK: - Asset

enum Asset: String {
    case music = "music"
    case podium = "podium"
    case star = "star"
    case heart = "heart"
    case pause = "pause"
    case fuel = "fuel"
    case menu = "menu"
    case playVideo = "play-video"
    case splash = "splash"
    case settings = "settings"
    case play = "play"
    
    func imageRepresentation() -> UIImage? {
        return UIImage(named: self.rawValue)
    }
}
