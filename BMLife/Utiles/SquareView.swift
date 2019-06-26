//
//  SquareView.swift
//  BMLife
//
//  Created by Zijia Zhai on 6/26/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class SquareView: UIView {
    static let viewW: CGFloat = 50
    static let Space: CGFloat = 10
    
    lazy var imageV: UIImageView = {
        let lview = UIImageView()
        return lview
    }()
    
    lazy var labelV: UILabel = {
        let lview = UILabel()
        lview.textAlignment = .center
        lview.textColor = UIColor.darkGray
        lview.font = UIFont.systemFont(ofSize: 10)
        return lview
    }()
    
    var data: [String]? {
        didSet {
            guard let data = data else {return}
            imageV = UIImageView(image: UIImage(named: data[0]))
            labelV.text = data[1]
            setupUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.borderWidth = 1
    }
    
    fileprivate func setupUI() {
        self.addSubview(imageV)
        imageV.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: SquareView.viewW/3, height: SquareView.viewW/3)
        imageV.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageV.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5).isActive = true
        
        self.addSubview(labelV)
        labelV.anchor(top: imageV.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        labelV.centerXAnchor.constraint(equalTo: imageV.centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
