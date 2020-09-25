//
//  GameManager.swift
//  Heatball
//
//  Created by Atilla Özder on 11.05.2020.
//  Copyright © 2020 Atilla Özder. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

// MARK: - GameManager

final class GameManager: NSObject {
    
    // MARK: - Properties
    
    static let shared = GameManager()
    
    var gameCount: Double = 0
    private(set) var gcEnabled = Bool()
    private(set) var gcDefaultLeaderBoard = String()
    
    private let workCount: Double = 1
    private var unitWorkValue: Double {
        return 1 / workCount
    }
    
    private var progressValue: Double = 0 {
        didSet {
            DispatchQueue.main.async {
                if let loadingProgress = self.progress {
                    loadingProgress(Float(self.progressValue))
                }
            }
        }
    }
    
    var progress: ((Float) -> ())?
    
    // MARK: - Private Constructor
    
    private override init() {
        super.init()
    }
    
    // MARK: - Helper Methods
    
    func submitNewScore(_ score: Int) {
        if gcEnabled {
            let highscore = GKScore(leaderboardIdentifier: Globals.leaderboardID)
            highscore.value = Int64(score)
                        
            GKScore.report([highscore]) { (error) in
                if let err = error {
                    print(err.localizedDescription)
                }
            }
        }
    }
    
    func authenticatePlayer(presentingViewController: UIViewController) {
        let defaults = UserDefaults.standard
        if defaults.shouldRequestGCAuthentication {
            let localPlayer = GKLocalPlayer.local
            localPlayer.authenticateHandler = { [weak self] (viewController, error) in
                guard let self = self else { return }
                if viewController != nil {
                    presentingViewController.present(viewController!, animated: true, completion: nil)
                    defaults.setGCRequestAuthentication()
                } else if localPlayer.isAuthenticated {
                    self.gcEnabled = true
                    defaults.setGCRequestAuthentication()
                } else {
                    self.gcEnabled = false
                    if let err = error {
                        print(err.localizedDescription)
                    }
                }
                self.progressValue += self.unitWorkValue
            }
        } else {
            self.progressValue += self.unitWorkValue
        }
    }
}

