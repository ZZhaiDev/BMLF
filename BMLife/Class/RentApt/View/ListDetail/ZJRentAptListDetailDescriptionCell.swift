//
//  ZJRentAptListDetailDescriptionCell.swift
//  BMLife
//
//  Created by Zijia Zhai on 6/7/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class ZJRentAptListDetailDescriptionCell: UICollectionViewCell {
    var data: String? {
        didSet {
            if data != nil {
                label.text = data!
            }
        }
    }

    lazy var label: UITextView = {
       let lable = UITextView(frame: .zero)
        lable.backgroundColor = .clear
        lable.layer.cornerRadius = 12
        lable.layer.masksToBounds = true
        lable.font = UIFont.systemFont(ofSize: 16)
        return lable
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        label.fillSuperview(padding: UIEdgeInsets(top: 0, left: 8, bottom: 15, right: 8))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
