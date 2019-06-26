//
//  ZJRentAptListDetailTitleView.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/21/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
private let userPhotoWidth: CGFloat = 50

class ZJRentAptListDetailTitleViewCell: UICollectionViewCell {
    static let selfHeight: CGFloat = 60
    var data = AddAptProperties() {
        didSet {
            if let description = data.description {
               titleLabel.text = description.title ?? ""
            }
        }
    }
    
    var realmData: String? {
        didSet {
            guard let realmData = realmData else { return }
            titleLabel.text = realmData
        }
    }

    fileprivate lazy var titleLabel: UILabel = {
       let lable = UILabel()
        lable.textColor = .black
        lable.text = ""
        lable.numberOfLines = 0
        lable.font = UIFont.boldSystemFont(ofSize: 22)
        lable.adjustsFontSizeToFitWidth = true
        lable.textAlignment = .center
        return lable
    }()

    fileprivate lazy var userPhoto: UIImageView = {
       let imageV = UIImageView(image: UIImage(named: "AppIcon"))
        imageV.layer.cornerRadius = userPhotoWidth/2
        imageV.layer.masksToBounds = true
        return imageV
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupUI() {
        self.addSubview(titleLabel)
        titleLabel.fillSuperview()
    }

}
