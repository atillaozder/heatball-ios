//
//  UserSettings.swift
//  HeatBall
//
//  Created by Atilla Özder on 6.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import Foundation

struct UserSettings {
    
    static let defaults = UserDefaults.standard
    
    static func toggleTheme() {
        defaults.set(theme.inverse.rawValue, forKey: "current_theme")
        NotificationCenter.default.post(.init(name: .didUpdateThemeNotification))
    }
    
    static var theme: Theme {
        let rawValue = defaults.value(forKey: "current_theme") as? String
        return Theme(rawValue: rawValue ?? "") ?? .normal
    }
    
    static func toggleSound() {
        defaults.set(!soundEnabled, forKey: "sound_enabled")
    }
    
    static var soundEnabled: Bool {
        return defaults.bool(forKey: "sound_enabled")
    }
    
    static func setHighestScore(_ score: Int) {
        if highestScore < score {
            defaults.set(score, forKey: "highest_score")
        }
    }
    
    static var highestScore: Int {
        return defaults.integer(forKey: "highest_score")
    }
}
