//
//  HeatTone.swift
//  Ball
//
//  Created by Atilla Özder on 5.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import UIKit

enum HeatTone: Int {
    case red1 = 1
    case red2 = 2
    case red3 = 3
    case red4 = 4
    case red5 = 5
    case red6 = 6
    case red7 = 7
    case red8 = 8
    case advRed = 9
    
    func asColor() -> UIColor {
        switch self {
        case .red1:
            return .init(red: 255, green: 205, blue: 210)
        case .red2:
            return .init(red: 239, green: 154, blue: 154)
        case .red3:
            return .init(red: 229, green: 115, blue: 115)
        case .red4:
            return .init(red: 239, green: 83, blue: 80)
        case .red5:
            return .init(red: 244, green: 67, blue: 54)
        case .red6:
            return .init(red: 229, green: 57, blue: 53)
        case .red7:
            return .init(red: 211, green: 47, blue: 47)
        case .red8:
            return .init(red: 190, green: 40, blue: 40)
        case .advRed:
            return .init(red: 255, green: 0, blue: 0)
        }
    }
}
