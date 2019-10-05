//
//  Extensions.swift
//  Ball
//
//  Created by Atilla Özder on 5.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import UIKit

extension UIView {
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }
    
    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        }
        return leadingAnchor
    }
    
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        }
        return trailingAnchor
    }
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
        return UIColor(red: .random(in: 0..<1),
                       green: .random(in: 0..<1),
                       blue: .random(in: 0..<1),
                       alpha: 1)
    }
}
