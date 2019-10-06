//
//  Theme.swift
//  HeatBall
//
//  Created by Atilla Özder on 6.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import UIKit

enum Theme: String {
    case normal = "normal"
    case dark = "dark"
    
    var inverse: Theme {
        switch self {
        case .normal:
            return .dark
        case .dark:
            return .normal
        }
    }
    
    func asColor() -> UIColor {
        switch self {
        case .normal:
            return .white
        case .dark:
            return .dark
        }
    }
    
    func inverseColor() -> UIColor {
        switch self {
        case .normal:
            return .dark
        case .dark:
            return .white
        }
    }
}
