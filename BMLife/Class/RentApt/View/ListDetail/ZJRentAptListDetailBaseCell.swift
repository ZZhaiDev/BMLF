//
//  ZJRentAptListBaseCell.swift
//  BMLF
//
//  Created by zijia on 5/21/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class ZJRentAptListDetailBaseCell: UICollectionViewCell {
    lazy var firstLabel: UILabel = {
       let labelV = UILabel()
        labelV.textColor = UIColor.lightGray
        labelV.font = UIFont.systemFont(ofSize: 15)
        return labelV
    }()

    lazy var secondtLabel: UILabel = {
        let labelV = UILabel()
        labelV.textColor = UIColor.black
        labelV.font = UIFont.boldSystemFont(ofSize: 16)
        labelV.numberOfLines = 0
        labelV.adjustsFontSizeToFitWidth = true
        return labelV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(firstLabel)
        firstLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: zjScreenWidth/4, height: 0)
        self.addSubview(secondtLabel)
        secondtLabel.anchor(top: topAnchor, left: firstLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
