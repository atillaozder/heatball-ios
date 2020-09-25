//
//  HomeMenu.swift
//  HeatBall
//
//  Created by Atilla Özder on 9.04.2020.
//  Copyright © 2020 Atilla Özder. All rights reserved.
//

import UIKit

// MARK: - HomeMenu

final class HomeMenu: Menu {
    
    weak var delegate: MenuDelegate?
 
    override func setup() {
        verticalStackView.alignment = .center
        setupNewGameButton()
        setupHorizontalStackView()
        super.setup()
    }
    
    // MARK: - Tap Handling

    @objc
    private func didTapPlay(_ sender: UIButton) {
        delegate?.menu(self, didUpdateGameState: .playing)
    }
    
    @objc
    private func didTapSettings(_ sender: UIButton) {
        delegate?.menu(self, didUpdateGameState: .settings)
    }
    
    @objc
    private func didTapRate(_ sender: UIButton) {
        sender.scale()
        delegate?.menu(self, didSelectOption: .rate)
    }
    
    @objc
    private func didTapLeaderboard(_ sender: UIButton) {
        delegate?.menu(self, didUpdateGameState: .leaderboard)
    }
    
    // MARK: - Private Helper Methods
    
    private func setupNewGameButton() {
        let playButton = buildSquareButton(with: .play)
        playButton.pinSize(to: .initialize(100))
        playButton.layer.cornerRadius = 12
        playButton.addTarget(self, action: #selector(didTapPlay(_:)), for: .touchUpInside)
        verticalStackView.addArrangedSubview(playButton)
    }

    private func setupHorizontalStackView() {
        let rateButton = buildSquareButton(with: .star)
        rateButton.addTarget(self, action: #selector(didTapRate(_:)), for: .touchUpInside)
                
        let leaderboardButton = buildSquareButton(with: .podium)
        leaderboardButton.addTarget(self,
                                    action: #selector(didTapLeaderboard(_:)),
                                    for: .touchUpInside)
        
        let settingsButton = buildSquareButton(with: .settings)
        settingsButton.addTarget(self, action: #selector(didTapSettings(_:)), for: .touchUpInside)
        
        let arrangedSubviews = [rateButton, leaderboardButton, settingsButton]
        let horizontalStackView = UIStackView(arrangedSubviews: arrangedSubviews)
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = spacing
        horizontalStackView.axis = .horizontal
        verticalStackView.addArrangedSubview(horizontalStackView)
    }
}

