//
//  Extensions.swift
//  Ball
//
//  Created by Atilla Özder on 5.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import UIKit
import SpriteKit

extension Notification.Name {
    static let didUpdateThemeNotification = Notification.Name(rawValue: "didUpdateThemeNotification")
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255,
                  green: CGFloat(green) / 255,
                  blue: CGFloat(blue) / 255,
                  alpha: 1)
    }
    
    class var dark: UIColor {
        return .init(red: 21, green: 21, blue: 21)
    }
    
    class var random: UIColor {
        let color = UIColor(red: .random(in: 0..<1),
                            green: .random(in: 0..<1),
                            blue: .random(in: 0..<1),
                            alpha: 1)
        
        return userSettings.currentTheme == .dark ?
            color.lighter() :
            color.darker()
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: abs(percentage))
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: -1 * abs(percentage))
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return self
        }
    }
}

extension CGFloat {
    func radians() -> CGFloat {
        return CGFloat.pi * (self / 180)
    }
}

extension UIDevice {
    var scaleMode: SKSceneScaleMode {
        return self.userInterfaceIdiom == .pad ?
            .aspectFit :
            .aspectFill
    }
}

extension SKScene {
    func childNode(withIdentifier identifier: Identifier) -> SKNode? {
        return childNode(withName: identifier.rawValue)
    }
}

extension SKLabelNode {
    static var defaultLabel: SKLabelNode {
        let lbl = SKLabelNode(fontNamed: userSettings.fontName)
        lbl.fontSize = 24
        lbl.fontColor = userSettings.currentTheme.inverseColor()
        lbl.zPosition = 999
        return lbl
    }
}
