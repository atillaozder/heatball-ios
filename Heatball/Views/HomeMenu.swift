//
//  HomeMenu.swift
//  Heatball
//
//  Created by Atilla Özder on 9.04.2020.
//  Copyright © 2020 Atilla Özder. All rights reserved.
//

import UIKit

class HomeMenu: Menu {
    
    weak var delegate: MenuDelegate?
    
    override func setup() {
        let playButton = buildSquareButton(asset: .play)
        playButton.pinSize(to: .initialize(100))
        playButton.layer.cornerRadius = 20
        playButton.addTarget(self, action: #selector(didTapPlay(_:)), for: .touchUpInside)
        
        stackView.alignment = .center
        stackView.addArrangedSubview(playButton)
        
        let rateButton = buildSquareButton(asset: .star)
        rateButton.addTarget(self, action: #selector(didTapRate(_:)), for: .touchUpInside)
        
        let leaderboardButton = buildSquareButton(asset: .podium)
        leaderboardButton.addTarget(
            self, action: #selector(didTapLeaderboard(_:)), for: .touchUpInside)
        
        let settingsButton = buildSquareButton(asset: .settings)
        settingsButton.addTarget(self, action: #selector(didTapSettings(_:)), for: .touchUpInside)
        
        let subviews: [UIView] = [settingsButton, leaderboardButton, rateButton]
        let sv = UIStackView(arrangedSubviews: subviews)
        sv.alignment = .center
        sv.distribution = .fillEqually
        sv.spacing = defaultSpacing
        sv.axis = .horizontal
        stackView.addArrangedSubview(sv)
        
        super.setup()
    }
    
    //    @objc
    //    func didTapToggleSound(_ sender: UIButton) {
    //        sender.scale()
    //        let newValue = !UserDefaults.standard.isSoundOn
    //        UserDefaults.standard.setSound(newValue)
    //        if let button = sender as? BackslashButton {
    //            button.backslashDrawable = !newValue
    //        }
    //
    //        newValue ?
    //            AudioPlayer.shared.playMusic() :
    //            AudioPlayer.shared.pauseMusic()
    //    }
    
    @objc
    func didTapPlay(_ sender: UIButton) {
        delegate?.menu(self, didUpdateGameState: .playing)
    }
    
    @objc
    func didTapSettings(_ sender: UIButton) {
        delegate?.menu(self, didUpdateGameState: .settings)
    }
    
    @objc
    func didTapRate(_ sender: UIButton) {
        sender.scale()
        delegate?.menu(self, didSelectOption: .rate)
    }
    
    @objc
    func didTapLeaderboard(_ sender: UIButton) {
        delegate?.menu(self, didUpdateGameState: .leaderboard)
    }
}

