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

    var data = AddAptProperties() {
        didSet {
            if let description = data.description {
               titleLabel.text = description.title ?? ""
            }
        }
    }

    fileprivate lazy var titleLabel: UILabel = {
       let lable = UILabel()
        lable.textColor = .black
        lable.text = ""
        lable.numberOfLines = 0
        lable.font = UIFont.boldSystemFont(ofSize: 22)
        lable.adjustsFontSizeToFitWidth = true
        lable.textAlignment = .left
        return lable
    }()

    fileprivate lazy var userPhoto: UIImageView = {
       let imageV = UIImageView(image: UIImage(named: "phone"))
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
        self.addSubview(userPhoto)
        self.addSubview(titleLabel)
        userPhoto.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: userPhotoWidth, height: userPhotoWidth)
        userPhoto.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.anchor(top: self.topAnchor, left: userPhoto.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 5, paddingRight: 10, width: 0, height: 0)
    }

}
