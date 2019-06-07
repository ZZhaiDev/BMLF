//
//  ZJRentAptListDetailContactCell.swift
//  BMLife
//
//  Created by Zijia Zhai on 6/7/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
private let leftPadding: CGFloat = 15
private let spacePadding: CGFloat = 10
private let topPadding: CGFloat = 0

class ZJRentAptListDetailContactCell: UICollectionViewCell {
    static let selfHeight: CGFloat = 130
    var data = AddAptContact(){
        didSet{
            
        }
    }
    
    lazy var phoneB: UIButton = {
       let b = UIButton()
        b.backgroundColor = .orange
        b.setTitle("Call: 654000333552", for: .normal)
        b.setTitleColor(.white, for: .normal)
        
        
        b.layer.cornerRadius = (ZJRentAptListDetailContactCell.selfHeight - 2*spacePadding)/3/2
        b.layer.masksToBounds = false
        b.layer.shadowColor = UIColor.lightGray.cgColor;
        b.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        b.layer.shadowOpacity = 1.0
        b.layer.shadowRadius = 0.0
        return b
    }()
    
    lazy var emailB: UIButton = {
        let b = UIButton()
        b.backgroundColor = .orange
        b.setTitle("Email: asdfsdff@/com", for: .normal)
        b.setTitleColor(.white, for: .normal)
        
        b.layer.cornerRadius = (ZJRentAptListDetailContactCell.selfHeight - 2*spacePadding)/3/2
        b.layer.masksToBounds = false
        b.layer.shadowColor = UIColor.lightGray.cgColor;
        b.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        b.layer.shadowOpacity = 1.0
        b.layer.shadowRadius = 0.0
        return b
    }()
    
    lazy var wechatL: UILabel = {
        let b = UILabel()
        b.text = "微信：dafasdfdafs"
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackV = UIStackView(arrangedSubviews: [phoneB, emailB, wechatL])
        stackV.backgroundColor = .red
        stackV.axis = .vertical
        stackV.distribution = .fillEqually
        stackV.setCustomSpacing(spacePadding, after: phoneB)
        stackV.setCustomSpacing(spacePadding, after: emailB)
        self.addSubview(stackV)
        stackV.fillSuperview(padding: UIEdgeInsets(top: topPadding, left: leftPadding, bottom: 0, right: zjScreenWidth/3))
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
