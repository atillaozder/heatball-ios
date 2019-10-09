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
    
    private var reward: GADAdReward?
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if #available(iOS 11.0, *) {
            if let view = self.view as? SKView, let scene = view.scene as? Scene {
                scene.safeAreaInsets = view.safeAreaInsets
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        
        if let view = self.view as? SKView {
            let scene: Scene = userSettings.isTutorialPresented ?
                GameScene(size: view.frame.size) :
                ScoreTutorialScene(size: view.frame.size)
            scene.sceneDelegate = self
            scene.scaleMode = UIDevice.current.scaleMode
            view.ignoresSiblingOrder = true
            view.presentScene(scene)
        }
        
        interstitial = createInterstitial()
        registerRemoteNotifications()
        GADRewardBasedVideoAd.sharedInstance().delegate = self
    }
    
    func updateTheme() {
        setBackgroundColor()
        scene?.updateTheme()
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = userSettings.currentTheme.asColor()
    }
    
    private func createInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: AppDelegate.interstitialIdentifier)
        interstitial.delegate = self
        interstitial.load(.init())
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
        return .init(arrayLiteral: .portrait)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: GADRewardBasedVideoAdDelegate {
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        self.reward = reward
    }

    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        let _ = reward != nil ?
            scene?.state.enter(Playing.self) :
            scene?.state.enter(GameOver.self)
        reward = nil
        
        GADRewardBasedVideoAd
            .sharedInstance()
            .load(.init(), withAdUnitID: AppDelegate.rewardBasedVideoAdIdentifier)
    }
}

extension GameViewController: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createInterstitial()
    }
}

extension GameViewController: SceneDelegate {
    func scene(_ scene: GameScene,
               shouldPresentRewardBasedVideoAd shouldPresent: Bool) {
        let rewardBasedVideoAd = GADRewardBasedVideoAd.sharedInstance()
        
        if rewardBasedVideoAd.isReady {
            rewardBasedVideoAd.present(fromRootViewController: self)
            scene.rewardBasedVideoAdPresented = true
        } else {
            scene.state.enter(GameOver.self)
            rewardBasedVideoAd
                .load(.init(), withAdUnitID: AppDelegate.rewardBasedVideoAdIdentifier)
        }
    }
    
    func scene(_ scene: GameScene,
               shouldPresentInterstitialAfterGame shouldPresent: Bool) {
        interstitial.isReady ?
            interstitial.present(fromRootViewController: self) :
            interstitial.load(.init())
    }

    func scene(_ scene: GameScene, didCreateNewScene newScene: GameScene) {
        newScene.sceneDelegate = self
    }
    
    func scene(_ scene: GameScene, didTapRateNode node: SKNode) {
        let urlString = "https://itunes.apple.com/app/id\(1482539751)?action=write-review"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
