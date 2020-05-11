//
//  SplashViewController.swift
//  Heatball
//
//  Created by Atilla Özder on 11.05.2020.
//  Copyright © 2020 Atilla Özder. All rights reserved.
//

import UIKit
import Firebase

class SplashViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let loadingProgress: UILabel = {
        let lbl = UILabel()
        lbl.font = .buildFont(withSize: 22)
        lbl.text = "0%"
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    var progress: Int {
        get { return Int(loadingProgress.text ?? "0") ?? 0 }
        set {
            self.loadingProgress.text =  "\(newValue)%"
            if newValue >= 100 {
                guard presentedViewController == nil else { return }
                self.presentGameController()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customPurple
                
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 12
        
        let imageView = UIImageView(image: Asset.splash.imageRepresentation())
        imageView.contentMode = .scaleAspectFit
        imageView.pinSize(to: .initialize(160))
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(red: 250, green: 250, blue: 250).cgColor
        imageView.clipsToBounds = true
        stackView.addArrangedSubview(imageView)

        let titleLabel = UILabel()
        titleLabel.text = "HEATBALL"
        titleLabel.font = .buildFont(Fonts.AmericanTypeWriter.bold, withSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        stackView.addArrangedSubview(titleLabel)
        
        let spacer = UIView()
        spacer.pinHeight(to: 24)
        stackView.addArrangedSubview(spacer)
        
        let loadingTitleLabel = UILabel()
        loadingTitleLabel.text = MainStrings.loadingTitle.localized
        loadingTitleLabel.font = .buildFont(Fonts.AmericanTypeWriter.semibold, withSize: 18)
        loadingTitleLabel.textAlignment = .center
        loadingTitleLabel.textColor = .white
        
        let rootStackView = UIStackView()
        rootStackView.alignment = .fill
        rootStackView.distribution = .fill
        rootStackView.axis = .vertical
        rootStackView.spacing = 12
        
        rootStackView.addArrangedSubview(stackView)
        rootStackView.addArrangedSubview(loadingProgress)
        rootStackView.addArrangedSubview(loadingTitleLabel)

        loadingProgress.pinHeight(to: 26)
        
        view.addSubview(rootStackView)
        rootStackView.pinCenterOfSuperview()
        if UIDevice.current.isPad {
            rootStackView.pinWidth(to: 300)
        } else {
            rootStackView.pinEdgesToView(
                view, insets: .viewEdge(32), exclude: [.top, .bottom])
        }
        
        startLoading()
    }
    
    private func startLoading() {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        UserDefaults.standard.setSession()
        GameManager.shared.authenticatePlayer(presentingViewController: self)
        
        GameManager.shared.progress = { [weak self] (progress) in
            guard let `self` = self else { return }
            self.progress = Int(progress * 100)
        }
    }
    
    private func presentGameController() {
        let viewController = GameViewController()
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}

