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
//                titleLabel.text =  "一室一厅招租，近地铁，进学校 900每月"
            }
        }
    }

    fileprivate lazy var titleLabel: UILabel = {
       let lable = UILabel()
        lable.textColor = .black
        lable.text = ""
        lable.numberOfLines = 0
//        l.font = UIFont.Weight.bold
        lable.font = UIFont.boldSystemFont(ofSize: 22)
        lable.adjustsFontSizeToFitWidth = true
        lable.textAlignment = .left
        return lable
    }()

    fileprivate lazy var userPhoto: UIImageView = {
       let up = UIImageView(image: UIImage(named: "phone"))
        up.layer.cornerRadius = userPhotoWidth/2
        up.layer.masksToBounds = true
        return up
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupUI() {
//        self.backgroundColor = .red
        self.addSubview(userPhoto)
        self.addSubview(titleLabel)
        userPhoto.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: userPhotoWidth, height: userPhotoWidth)
        userPhoto.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.anchor(top: self.topAnchor, left: userPhoto.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 5, paddingRight: 10, width: 0, height: 0)
    }

}
