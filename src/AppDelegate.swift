//
//  AppDelegate.swift
//  Ball
//
//  Created by Atilla Özder on 5.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import UIKit
import SpriteKit
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var interstitialIdentifier: String {
        #if DEBUG
        return "ca-app-pub-3940256099942544/4411468910"
        #else
        return "ca-app-pub-3176546388613754/7237544772"
        #endif
    }

    var window: UIWindow?
    lazy var rootViewController = GameViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .dark
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if let view = rootViewController.view as? SKView {
            view.scene?.view?.isPaused = true
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if let view = rootViewController.view as? SKView {
            view.scene?.view?.isPaused = false
        }
    }
}
