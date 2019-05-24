//
//  InfoContentCell.swift
//  find-my-parking
//
//  Created by Tieda Wei on 2019-04-21.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import UIKit

class InfoContentCell: UICollectionViewCell {
    
    let descriptionLabel: UITextView = {
        let tv = UITextView()
        
        let attributedText = NSMutableAttributedString(string: NSLocalizedString("ifYou", comment: ""), attributes: [.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        
        attributedText.append(NSAttributedString(string: NSLocalizedString("wereLike", comment: ""), attributes: [.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        attributedText.append(NSAttributedString(string: NSLocalizedString("aboutData", comment: ""), attributes: [.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 4)]))
        
        attributedText.append(NSAttributedString(string: NSLocalizedString("theParking", comment: ""), attributes: [.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        attributedText.append(NSAttributedString(string: NSLocalizedString("I'llTry", comment: ""), attributes: [.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        attributedText.append(NSAttributedString(string: NSLocalizedString("suggestions", comment: ""), attributes: [.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        attributedText.append(NSAttributedString(string: "\n\n\nFind My Parking", attributes: [.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]))
        
        attributedText.append(NSAttributedString(string: NSLocalizedString("isFully", comment: ""), attributes: [.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        let github = NSAttributedString(string: "GitHub", attributes:[NSAttributedString.Key.link: URL(string: "https://github.com/weitieda/find-my-parking")!, .font: UIFont.systemFont(ofSize: 20, weight: .regular)])
        attributedText.append(github)
        
        attributedText.append(NSAttributedString(string: ".\n", attributes: [.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        tv.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        tv.attributedText = attributedText
        tv.isUserInteractionEnabled = true
        tv.isScrollEnabled = false
        tv.isEditable = false
        
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(descriptionLabel)
        descriptionLabel.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}

