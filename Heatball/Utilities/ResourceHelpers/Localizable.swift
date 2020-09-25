//
//  Localizable.swift
//  HeatBall
//
//  Created by Atilla Özder on 25.09.2020.
//  Copyright © 2020 Atilla Özder. All rights reserved.
//

import Foundation

// MARK: - Strings

enum Strings: String {
    case score = "scoreTitle"
    case highscore = "highscoreTitle"
    case newGame = "newGameTitle"
    case settings = "settingsTitle"
    case backToMenu = "backToMenuTitle"
    case rate = "rateTitle"
    case support = "supportTitle"
    case privacy = "privacyTitle"
    case otherApps = "otherAppsTitle"
    case share = "shareTitle"
    case continueTitle = "continueTitle"
    case choose = "chooseTitle"
    case loading = "loadingTitle"
    case ok = "okTitle"
    case gcErrorMessage = "gcErrorMessage"
    case resetDataSharing = "resetDataSharingConfigurationsTitle"
    
    var localized: String {
        NSLocalizedString(self.rawValue, comment: "")
    }
    
    var uppercased: String {
        localized.uppercased(with: .current)
    }
    
    var capitalized: String {
        localized.capitalized(with: .current)
    }
}
