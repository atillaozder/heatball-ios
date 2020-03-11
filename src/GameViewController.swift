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
        guard let view = self.view as? SKView else { return nil }
        return view.scene as? GameScene
    }
    
    override func loadView() {
        view = SKView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            guard let view = self.view as? SKView else { return }
            if let scene = view.scene as? Scene {
                scene.insets = view.safeAreaInsets
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        presentGameScreen()
        registerRemoteNotifications()
        interstitial = createInterstitial()
        GADRewardBasedVideoAd.sharedInstance().delegate = self
    }
    
    func presentGameScreen() {
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.frame.size)
            scene.sceneDelegate = self
            scene.scaleMode = UIDevice.current.scaleMode
            if #available(iOS 11.0, *) {
                scene.insets = view.safeAreaInsets
            }
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
        }
    }
    
    func updateMode() {
        setBackgroundColor()
        scene?.updateMode()
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = userSettings.selectedColor
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
        return false
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
            scene?.state.enter(PlayingState.self) :
            scene?.state.enter(GameOverState.self)
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
               shouldPresentRewardBasedVideoAd present: Bool) {
        
        let rewardBasedVideoAd = GADRewardBasedVideoAd.sharedInstance()
        
        if rewardBasedVideoAd.isReady {
            rewardBasedVideoAd.present(fromRootViewController: self)
            scene.rewardBasedVideoAdPresented = true
        } else {
            scene.state.enter(GameOverState.self)
            rewardBasedVideoAd
                .load(.init(), withAdUnitID: AppDelegate.rewardBasedVideoAdIdentifier)
        }
    }
    
    func scene(_ scene: GameScene,
               shouldPresentInterstitial present: Bool) {
        if present {
            interstitial.isReady ?
                interstitial.present(fromRootViewController: self) :
                interstitial.load(.init())
        }
    }

    func scene(_ scene: GameScene, didCreateNewScene newScene: GameScene) {
        newScene.sceneDelegate = self
    }
    
    func scene(_ scene: GameScene, didTapRateNode node: SKNode) {
        let urlString = "https://itunes.apple.com/app/id\(1482539751)?action=write-review"
        if let url = URL(string: urlString) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
