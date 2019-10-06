//
//  GameViewController.swift
//  Ball
//
//  Created by Atilla Özder on 5.10.2019.
//  Copyright © 2019 Atilla Özder. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController {
    
    private var interstitial: GADInterstitial!
    
    private var scene: GameScene? {
        if let view = self.view as? SKView, let gameScene = view.scene as? GameScene {
            return gameScene
        }
        return nil
    }
    
    override func loadView() {
        view = SKView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UserSettings.theme.asColor()
        
        if let view = self.view as? SKView {
            let scene = GameScene(size: view.frame.size)
            scene.gameDelegate = self
            scene.scaleMode = UIDevice.current.userInterfaceIdiom == .pad ? .aspectFit : .aspectFill
            view.ignoresSiblingOrder = true
            view.presentScene(scene)
        }
        
        interstitial = createInterstitial()
        registerRemoteNotifications()
    }
    
    func setTheme() {
        view.backgroundColor = UserSettings.theme.asColor()
        scene?.setTheme()
    }
    
    private func createInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: AppDelegate.interstitialIdentifier)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    private func registerRemoteNotifications() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current()
            .requestAuthorization(options: options) { (_, _) in
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
        }
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createInterstitial()
    }
}

extension GameViewController: GameSceneDelegate {
    func scene(_ scene: GameScene, didOverGame gameOver: Bool) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            interstitial.load(GADRequest())
        }
    }
    
    func scene(_ scene: GameScene, didCreateNewScene newScene: GameScene) {
        newScene.gameDelegate = self
    }
    
    func scene(_ scene: GameScene, didTapRate rate: Bool) {
        let urlString = "https://itunes.apple.com/app/id\(1482539751)?action=write-review"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
