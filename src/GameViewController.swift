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
    
    override func loadView() {
        view = SKView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dark
        
        if let view = self.view as? SKView {
            let scene = GameScene(size: view.frame.size)
            scene.gameDelegate = self
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
        }
        
        interstitial = createInterstitial()
        
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (_, _) in }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func createInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: AppDelegate.interstitialIdentifier)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
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
            let request = GADRequest()
            interstitial.load(request)
        }
    }
    
    func scene(_ scene: GameScene, didCreateNewScene newScene: GameScene) {
        newScene.gameDelegate = self
    }
}
