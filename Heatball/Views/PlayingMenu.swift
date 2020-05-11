//
//  PlayingMenu.swift
//  Heatball
//
//  Created by Atilla Özder on 14.04.2020.
//  Copyright © 2020 Atilla Özder. All rights reserved.
//

import UIKit

// MARK: - PlayingMenu
class PlayingMenu: Menu {
    
    // MARK: - Properties
    private var isAnimated: Bool = false
    weak var delegate: MenuDelegate?

    lazy var scoreLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.font = UIDevice.current.isPad ? .buildFont(withSize: 24) : .buildFont(withSize: 18)
        lbl.text = MainStrings.scoreTitle.localized + ": 0"
        return lbl
    }()
    
    lazy var livesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var pauseContainer: UIView = {
        let btn = BackslashButton()
        btn.lineWidth = Globals.borderWidth + 2
        let image = Asset.pause.imageRepresentation()?.withRenderingMode(.alwaysTemplate)
        btn.setImage(image, for: .normal)
        btn.imageEdgeInsets = UIDevice.current.isPad ? .initialize(4) : .initialize(2)
        let size: CGSize = .initialize(UIDevice.current.isPad ? 70 : 40)
        let container = btn.buildContainer(withSize: size, cornerRadius: size.height / 2)
        
        let tappableView = UIView()
        tappableView.addSubview(container)
        tappableView.pinSize(to: .initialize(size.width * 1.5))
        
        let padding: CGFloat = UIDevice.current.isPad ? 16 : 8
        container.pinTop(to: tappableView.topAnchor, constant: padding)
        container.pinTrailing(to: tappableView.trailingAnchor, constant: -padding)
        return tappableView
    }()
    
    override func setup() {
        setupPauseButton()
        setupScoreButton()
        
        self.isHidden = true
        self.backgroundColor = nil
    }
    
    func reset() {
        setScore(0)
        setLifeCount(3)
        isHidden = false
    }
    
    func setScore(_ score: Double) {
        scoreLabel.text = MainStrings.scoreTitle.localized + ": \(Int(score))"
    }
    
    func setLifeCount(_ count: Int) {
        let previousCount = livesStackView.arrangedSubviews.count
        if previousCount > count {
            guard let lifeView = livesStackView.arrangedSubviews.last else { return }
            livesStackView.removeArrangedSubview(lifeView)
            lifeView.removeFromSuperview()
        } else {
            addLives(count)
        }
    }
    
    private func setupPauseButton() {
        self.addSubview(pauseContainer)
        pauseContainer.pinTop(to: safeTopAnchor)
        pauseContainer.pinTrailing(to: safeTrailingAnchor)
        pauseContainer.addTapGesture(target: self, action: #selector(didTapPause(_:)))
    }
    
    private func setupScoreButton() {
        let scoreStack = UIStackView(arrangedSubviews: [scoreLabel, livesStackView])
        scoreStack.spacing = 6
        scoreStack.alignment = .center
        scoreStack.distribution = .fill
        scoreStack.axis = .vertical
        
        addSubview(scoreStack)
        let constant: CGFloat = UIDevice.current.isPad ? 16 : 12
        scoreStack.pinTop(to: safeTopAnchor, constant: constant)
        scoreStack.pinLeading(to: safeLeadingAnchor, constant: constant)
    }

    private func addLives(_ count: Int) {
        livesStackView.arrangedSubviews.forEach { (lifeView) in
            livesStackView.removeArrangedSubview(lifeView)
            lifeView.removeFromSuperview()
        }
        
        let constant: CGFloat = UIDevice.current.isPad ? 25 : 15
        for _ in 0..<count {
            let imageView = UIImageView(image: Asset.heart.imageRepresentation()?.withRenderingMode(.alwaysTemplate))
            imageView.tintColor = .main
            imageView.contentMode = .scaleAspectFit
            imageView.makeSquare(constant: constant)
            livesStackView.addArrangedSubview(imageView)
        }
    }
    
    @objc
    func didTapPause(_ sender: UITapGestureRecognizer) {
        sender.view?.scale()
        delegate?.menu(self, didUpdateGameState: .paused)
    }
}
