//
//  Globals.swift
//  Heatball
//
//  Created by Atilla Özder on 11.05.2020.
//  Copyright © 2020 Atilla Özder. All rights reserved.
//

import UIKit
import SpriteKit

// MARK: - Globals

struct Globals {
    
    // MARK: - Tags
    
    enum Tags: Int {
        case toast = 1000
    }
    
    // MARK: - Keys
    
    enum Keys: String {
        case kScore = "score"
        case kSession = "session"
        case kSoundPreference = "sound_preference"
        case kHighscore = "best_score"
        case kBlock = "block"
        case kPlayer = "player"
        case kGCRequestAuthentication = "kGCRequestAuthentication"
        case kAddBlock = "add_block"
    }
    
    static var borderWidth: CGFloat { 2 }
    static var bundleID: String { "com.atillaozder.Heatball" }
    static var leaderboardID: String { "\(bundleID).Leaderboard" }
    static var appID: String { "1482539751" }
    
    private static var applicationViewControllerState: RootViewControllerType { .splash }
    
    private enum RootViewControllerType {
        case splash, game
    }

    static var rootViewController: UIViewController {
        #if DEBUG
        switch applicationViewControllerState {
        case .splash:
            return SplashViewController()
        case .game:
            return GameViewController()
        }
        #else
        return SplashViewController()
        #endif
    }
}
