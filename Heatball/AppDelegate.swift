//
//  AppDelegate.swift
//  HeatBall
//
//  Created by Atilla Özder on 5.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
        
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = Globals.rootViewController
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        
        window.backgroundColor = .background
        window.rootViewController = viewController
        
        self.window = window
        window.makeKeyAndVisible()

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: .shouldStayPausedNotification, object: nil)
    }
}

@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
