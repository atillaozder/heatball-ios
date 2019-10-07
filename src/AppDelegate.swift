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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var interstitialIdentifier: String {
        #if DEBUG
        return "ca-app-pub-3940256099942544/4411468910"
        #else
        return "ca-app-pub-3176546388613754/7237544772"
        #endif
    }
    
    static var rewardBasedVideoAdIdentifier: String {
        #if DEBUG
        return "ca-app-pub-3940256099942544/1712485313"
        #else
        return "ca-app-pub-3176546388613754/7634389777"
        #endif
    }

    var window: UIWindow?
    lazy var rootViewController = GameViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADRewardBasedVideoAd.sharedInstance()
            .load(GADRequest(), withAdUnitID: AppDelegate.rewardBasedVideoAdIdentifier)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = userSettings.currentTheme.asColor()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTheme), name: .didUpdateThemeNotification, object: nil)
        
        return true
    }
    
    @objc
    func updateTheme() {
        window?.backgroundColor = userSettings.currentTheme.asColor()
        rootViewController.updateTheme()
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}
