//
//  UserSettings.swift
//  HeatBall
//
//  Created by Atilla Özder on 6.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import UIKit
import SpriteKit

struct UserSettings {
    
    let sound = SKAction.playSoundFileNamed("pongBlip", waitForCompletion: false)
    let fontName = "AmericanTypewriter-semibold" // UIFont.systemFont(ofSize: 1).fontName
    let defaults = UserDefaults.standard
    
    var currentTheme: Theme {
        let rawValue = defaults.value(forKey: "current_theme") as? String
        return Theme(rawValue: rawValue ?? "") ?? .dark
    }

    var isSoundEnabled: Bool {
        return defaults.bool(forKey: "is_sound_enabled")
    }
    
    var isTutorialPresented: Bool {
        return defaults.bool(forKey: "is_tutorial_presented")
    }
    
    var highestScore: Int {
        return defaults.integer(forKey: "highest_score")
    }
    
    func toggleTheme() {
        defaults.set(currentTheme.inverse.rawValue, forKey: "current_theme")
        NotificationCenter.default.post(.init(name: .didUpdateThemeNotification))
    }
    
    func toggleSound() {
        defaults.set(!isSoundEnabled, forKey: "is_sound_enabled")
    }
    
    func tutorialPresented() {
        defaults.set(true, forKey: "is_tutorial_presented")
    }

    func setHighestScore(_ score: Int) {
        if highestScore < score {
            defaults.set(score, forKey: "highest_score")
        }
    }
}
