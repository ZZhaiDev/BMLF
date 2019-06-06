//
//  InfoContentCell.swift
//  find-my-parking
//
//  Created by Tieda Wei on 2019-04-21.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import UIKit

class InfoContentCell: UICollectionViewCell {
    
    let title1 = UILabel()
    let title2 = UILabel()
    let content1 = UILabel()
    let icon = UIImageView()
    let labelStack = UIStackView()
    let content2 = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        title1.textColor = .white
        title2.textColor = .white
        content1.textColor = .white
        content2.textColor = .white
        
        let labels = [title1, content1, title2, content2]
        labels.forEach { label in
            label.numberOfLines = 0
            labelStack.addArrangedSubview(label)
        }
        labelStack.spacing = 10
        labelStack.axis = .vertical
        addSubview(labelStack)
        labelStack.fillSuperview()
        
        title1.font = UIFont.boldSystemFont(ofSize: 32)
        title1.text = "Developers:"
        content1.text = """
        Zijia Zhai: iOS Developer😍
        Honglei Zhou: Backend Developer😍
        """
        title2.font = UIFont.boldSystemFont(ofSize: 32)
        title2.text = "Contacts:"
        content2.text = """
        If you want to report a bug, contact us;
        If you want to hire us, contact us;
        If you have any questions, contact us;
        """
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

