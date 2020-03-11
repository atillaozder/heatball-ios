//
//  UserSettings.swift
//  HeatBall
//
//  Created by Atilla Özder on 6.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import UIKit
import SpriteKit

// MARK: - UserSettings

struct UserSettings {
    
    // MARK: - Mode
    enum Mode: String {
        case dark = "dark"
        case white = "white"
        
        var inverse: Mode {
            switch self {
            case .white:
                return .dark
            case .dark:
                return .white
            }
        }
        
        func asColor() -> UIColor {
            switch self {
            case .white:
                return .white
            case .dark:
                return .dark
            }
        }
        
        func inverseColor() -> UIColor {
            switch self {
            case .white:
                return .dark
            case .dark:
                return .white
            }
        }
    }
    
    var isDarkModeEnabled: Bool {
        return currentMode == .dark
    }
    
    var selectedColor: UIColor {
        return currentMode.asColor()
    }
        
    var currentMode: Mode {
        let rawValue = UserDefaults.standard.value(forKey: "current_mode") as? String ?? ""
        return Mode(rawValue: rawValue) ?? .dark
    }

    var isSoundEnabled: Bool {
        return UserDefaults.standard.bool(forKey: "is_sound_enabled")
    }
    
    var isTutorialPresented: Bool {
        return UserDefaults.standard.bool(forKey: "is_tutorial_presented")
    }
    
    var bestScore: Int {
        return UserDefaults.standard.integer(forKey: "best_score")
    }
        
    func toggleMode() {
        UserDefaults.standard.set(currentMode.inverse.rawValue, forKey: "current_mode")
        NotificationCenter.default.post(.init(name: .didUpdateModeNotification))
    }
    
    func toggleSound() {
        UserDefaults.standard.set(!isSoundEnabled, forKey: "is_sound_enabled")
    }
    
    func setTutorialPresented() {
        UserDefaults.standard.set(true, forKey: "is_tutorial_presented")
    }

    func setBestScore(_ score: Int) {
        if bestScore < score {
            UserDefaults.standard.set(score, forKey: "best_score")
        }
    }
}
