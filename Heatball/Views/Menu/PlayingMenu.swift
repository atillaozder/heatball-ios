//
//  PlayingMenu.swift
//  HeatBall
//
//  Created by Atilla Özder on 14.04.2020.
//  Copyright © 2020 Atilla Özder. All rights reserved.
//

import UIKit

// MARK: - PlayingMenu

final class PlayingMenu: Menu {
    
    // MARK: - Properties
    
    private var isAnimated: Bool = false
    weak var delegate: MenuDelegate?
    
    private lazy var scoreLabel: UILabel = buildScoreLabel()
    private lazy var horizontalLivesStackView: UIStackView = buildHorizontalLivesStackView()
    private lazy var pauseButton: UIView = buildPauseButton()
    
    // MARK: - Setup Views
    
    override func setup() {
        setupPauseButton()
        setupScoreVerticalStackView()
        self.isHidden = true
        self.backgroundColor = nil
    }
    
    // MARK: - Helper Methods

    func setScore(_ score: Double) {
        scoreLabel.text = Strings.score.localized + ": \(Int(score))"
    }
    
    func setLifeCount(_ count: Int) {
        let previousCount = horizontalLivesStackView.arrangedSubviews.count
        if previousCount > count {
            guard let subview = horizontalLivesStackView.arrangedSubviews.last else { return }
            horizontalLivesStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        } else {
            addLives(count)
        }
    }
    
    func reset() {
        setScore(0)
        setLifeCount(3)
        isHidden = false
    }
    
    // MARK: - Tap Handling
    
    @objc
    private func didTapPause(_ sender: UITapGestureRecognizer) {
        sender.view?.scale()
        delegate?.menu(self, didUpdateGameState: .paused)
    }
    
    // MARK: - Private Helper Methods
    
    private func addLives(_ count: Int) {
        horizontalLivesStackView.arrangedSubviews.forEach { (subview) in
            horizontalLivesStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        let constant: CGFloat = 15
        for _ in 0..<count {
            let imageView = UIImageView(image: Asset.heart.imageRepresentation()?.withRenderingMode(.alwaysTemplate))
            imageView.tintColor = .primary
            imageView.contentMode = .scaleAspectFit
            imageView.makeSquare(constant: constant)
            horizontalLivesStackView.addArrangedSubview(imageView)
        }
    }
    
    private func setupScoreVerticalStackView() {
        let verticalStackView = UIStackView(arrangedSubviews: [scoreLabel, horizontalLivesStackView])
        verticalStackView.spacing = 6
        verticalStackView.alignment = .center
        verticalStackView.distribution = .fill
        verticalStackView.axis = .vertical
        
        addSubview(verticalStackView)
        let constant: CGFloat = 8
        verticalStackView.pinTop(to: safeTopAnchor, constant: constant)
        verticalStackView.pinLeading(to: safeLeadingAnchor, constant: constant)
    }
    
    private func setupPauseButton() {
        self.addSubview(pauseButton)
        pauseButton.pinTop(to: safeTopAnchor)
        pauseButton.pinTrailing(to: safeTrailingAnchor)
        pauseButton.addTapGesture(target: self, action: #selector(didTapPause(_:)))
    }
    
    private func buildScoreLabel() -> UILabel {
        let scoreLabel = UILabel()
        scoreLabel.textColor = UIColor.white
        scoreLabel.font = .boldSystemFont(ofSize: 18)
        scoreLabel.text = Strings.score.localized + ": 0"
        return scoreLabel
    }
    
    private func buildHorizontalLivesStackView() -> UIStackView {
        let horizontalStackView = UIStackView()
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 4
        horizontalStackView.axis = .horizontal
        return horizontalStackView
    }
    
    private func buildPauseButton() -> UIView {
        let pauseButton = BackslashButton()
        pauseButton.lineWidth = Globals.borderWidth + 2
        
        let image = Asset.pause.imageRepresentation()?.withRenderingMode(.alwaysTemplate)
        pauseButton.setImage(image, for: .normal)
        pauseButton.imageEdgeInsets = .initialize(2)
        
        let height: CGFloat = 40
        let size: CGSize = .initialize(height)
        let containerView = pauseButton.buildContainer(withSize: size, cornerRadius: size.height / 2)
        
        let enlargedContainerView = UIView()
        enlargedContainerView.addSubview(containerView)
        enlargedContainerView.pinSize(to: .initialize(size.width * 1.5))
        
        let padding: CGFloat = 8
        containerView.pinTop(to: enlargedContainerView.topAnchor, constant: padding)
        containerView.pinTrailing(to: enlargedContainerView.trailingAnchor, constant: -padding)
        return enlargedContainerView
    }
}
