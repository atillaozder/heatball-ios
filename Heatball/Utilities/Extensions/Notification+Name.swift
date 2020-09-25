//
//  Notification+Name.swift
//  HeatBall
//
//  Created by Atilla Özder on 25.09.2020.
//  Copyright © 2020 Atilla Özder. All rights reserved.
//

import Foundation

// MARK: - NSNotification

extension NSNotification.Name {
    static let shouldStayPausedNotification = Notification.Name("shouldStayPausedNotification")
    static let didUpdateColorModeNotification = Notification.Name(rawValue: "didUpdateColorModeNotification")
}
