//
//  ImageHeader.swift
//  find-my-parking
//
//  Created by Tieda Wei on 2019-04-21.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import UIKit

class InfoImageHeader: UICollectionReusableView {
    
    var animator: UIViewPropertyAnimator!
    
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "bg"))
    fileprivate let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        setupImageView()
        setupBlurView()
        setupGradientLayer()
        setupTitleLable()
    }
    
    fileprivate func setupImageView() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.fillSuperview()
    }
    
    fileprivate func setupBlurView() {
        animator = UIViewPropertyAnimator(duration: 2, curve: .linear, animations: { [unowned self] in
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
            
            self.addSubview(blurView)
            blurView.fillSuperview()
            self.bringSubviewToFront(self.titleLabel)
        })
        self.animator.pausesOnCompletion = true
    }
    
    fileprivate func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1]
        
        let gradientContainer = UIView()
        addSubview(gradientContainer)
        gradientContainer.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        gradientContainer.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = self.bounds
        gradientLayer.frame.origin.y -= bounds.height
    }
    
    fileprivate func setupTitleLable() {
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 24, bottom: 16, right: 16))
        titleLabel.numberOfLines = 0
        
        let attributedText = NSMutableAttributedString(string:  NSLocalizedString("Welcome to", comment: ""), attributes: [.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)])
        attributedText.append(NSAttributedString(string: "\n", attributes: [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4, weight: .heavy)]))
        attributedText.append(NSAttributedString(string: "BMLife", attributes: [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32, weight: .heavy)]))
        titleLabel.attributedText = attributedText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
