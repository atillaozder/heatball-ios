//
//  Utilities.swift
//  Heatball
//
//  Created by Atilla Özder on 11.05.2020.
//  Copyright © 2020 Atilla Özder. All rights reserved.
//

import UIKit
import SpriteKit

// MARK: - Globals
struct Globals {
    static var borderWidth: CGFloat {
        return UIDevice.current.isPad ? 5 : 3
    }
}

// MARK: - GameObject
enum GameObject: String {
    case block = "block"
    case player = "player"
}

// MARK: - Category
enum Category: UInt32 {
    case block = 0x10
    case player = 0x1
    case none = 0x10000
}

// MARK: - Effect
enum Effect {
    case pop
}

// MARK: - GameHelper
class GameHelper {
    
    // MARK: - Properties
    let popSound = SKAction.playSoundFileNamed("pop.aiff", waitForCompletion: false)
            
    // MARK: - Helpers
    func playEffect(_ effect: Effect, in scene: SKScene) {
        if UserDefaults.standard.isSoundOn {
            switch effect {
            case .pop:
                scene.run(popSound)
            }
        }
    }
}

// MARK: - MainStrings
enum MainStrings: String {
    case scoreTitle = "scoreTitle"
    case highscoreTitle = "highscoreTitle"
    case newGameTitle = "newGameTitle"
    case settingsTitle = "settingsTitle"
    case backToMenuTitle = "backToMenuTitle"
    case rateTitle = "rateTitle"
    case supportTitle = "supportTitle"
    case privacyTitle = "privacyTitle"
    case otherAppsTitle = "otherAppsTitle"
    case shareTitle = "shareTitle"
    case continueTitle = "continueTitle"
    case chooseTitle = "chooseTitle"
    case loadingTitle = "loadingTitle"
    case okTitle = "okTitle"
    case gcErrorMessage = "gcErrorMessage"
        
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

// MARK: - URLNavigator
class URLNavigator {
    
    static let shared = URLNavigator()
    
    private init() {}
    
    @discardableResult
    func open(_ url: URL) -> Bool {
        let application = UIApplication.shared
        guard application.canOpenURL(url) else { return false }
        
        if #available(iOS 10.0, *) {
            application.open(url, options: [:], completionHandler: nil)
        } else {
            application.openURL(url)
        }
        
        return true
    }
    
    @discardableResult
    func open(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return open(url)
    }
}

// MARK: - Asset
enum Asset: String {
    case music = "music"
    case podium = "podium"
    case star = "star"
    case heart = "heart"
    case pause = "pause"
    case fuel = "fuel"
    case menu = "menu"
    case roll = "roll"
    case background = "background"
    case splash = "splash"
    
    func imageRepresentation() -> UIImage? {
        return UIImage(named: self.rawValue)
    }
}

// MARK: - FontNameRepresentable
protocol FontNameRepresentable {
    var fontName: String { get }
}

// MARK: - Fonts
struct Fonts {
    
    enum Courier: String, FontNameRepresentable {
        case bold = "-Bold"
        case regular = ""
        
        var fontName: String {
            return "Courier\(rawValue)"
        }
    }
    
    enum AmericanTypeWriter: String, FontNameRepresentable {
        case bold = "-Bold"
        case semibold = "-Semibold"
        case condensed = "-Condensed"
        case condensedBold = "-CondensedBold"
        case light = "-Light"
        case regular = ""
        
        var fontName: String {
            return "AmericanTypewriter\(rawValue)"
        }
    }
}
