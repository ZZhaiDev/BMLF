//
//  ZJRentAptFilterHotView.swift
//  BMLife
//
//  Created by Zijia Zhai on 6/5/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class ZJRentAptFilterHotView: UIView {
    
    fileprivate lazy var titles = ["Chicago", "San Francisco", "Los Angeles", "New York", "Dallas", "San Jose", "Seattle"]
    fileprivate var ynCategoryButtons = [YNCategoryButton]()
    fileprivate var ynCategoryButtonType: YNCategoryButtonType = .colorful
    
    fileprivate lazy var hotImageV: UIImageView = {
       let iv = UIImageView(image: UIImage(named: "home_header_hot"))
        return iv
    }()
    
    fileprivate lazy var hotLable: UILabel = {
       let l = UILabel(frame: .zero)
        l.font = UIFont.systemFont(ofSize: 14)
        l.text = "Hot :"
        l.textColor = UIColor.red
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .blue
        self.addSubview(hotImageV)
        hotImageV.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 18, height: 18)
        self.addSubview(hotLable)
        hotLable.anchor(top: hotImageV.topAnchor, left: hotImageV.rightAnchor, bottom: hotImageV.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        setupButtons()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtons(){
        let margin: CGFloat = 15
        var formerWidth: CGFloat = 15
        var formerHeight: CGFloat = 40
        
        
        let font = UIFont.systemFont(ofSize: 12)
        let userAttributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor: UIColor.gray]
        for i in 0..<titles.count {
            let size = titles[i].size(withAttributes: userAttributes)
            if i > 0 {
                formerWidth = ynCategoryButtons[i-1].frame.size.width + ynCategoryButtons[i-1].frame.origin.x + 10
                if formerWidth + size.width + margin > UIScreen.main.bounds.width {
                    formerHeight += ynCategoryButtons[i-1].frame.size.height + 10
                    formerWidth = margin
                }
            }
            let button = YNCategoryButton(frame: CGRect(x: formerWidth, y: formerHeight, width: size.width + 10, height: size.height + 10))
            button.setType(type: ynCategoryButtonType)
            button.addTarget(self, action: #selector(ynCategoryButtonClicked(sender:)), for: .touchUpInside)
            button.setTitle(titles[i], for: .normal)
            button.tag = i
            
            ynCategoryButtons.append(button)
            self.addSubview(button)
            
        }
    }
    
    @objc fileprivate func ynCategoryButtonClicked(sender: UIButton){
        let title = titles[sender.tag]
        if let topVC = UIApplication.topViewController() as? ZJRentAptFilterViewController{
            topVC.dismissWithCity(city: title)
        }
    }
}
