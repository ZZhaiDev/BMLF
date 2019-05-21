//
//  ZJRentAptListDetailCatrgories.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/21/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class ZJRentAptListDetailCatrgories: UIView {
    fileprivate lazy var crimeButton: UIButton = {
       let b = UIButton()
        b.setTitle("Crime", for: .normal)
        b.setTitleColor(.black, for: .normal)
        return b
    }()
    
    fileprivate lazy var streetViewButton: UIButton = {
        let b = UIButton()
        b.setTitle("Street View", for: .normal)
        b.setTitleColor(.black, for: .normal)
        return b
    }()
    
    fileprivate lazy var otherButton: UIButton = {
        let b = UIButton()
        b.setTitle("other", for: .normal)
        b.setTitleColor(.black, for: .normal)
        return b
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
        let stackView = UIStackView(arrangedSubviews: [crimeButton, streetViewButton, otherButton])
        stackView.backgroundColor = .black
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        self.addSubview(stackView)
        stackView.fillSuperview()
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
}
