//
//  ZJRentApiListTopSettingView.swift
//  BMLife
//
//  Created by Zijia Zhai on 6/21/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
private let leftRightPadding: CGFloat = 15
private let defaultColor: UIColor = UIColor.gray
private let selectedColor: UIColor = UIColor.darkText

class ZJRentApiListTopSettingView: UIView {
    static let selfHeight: CGFloat = 100
    let realEstate = UILabel()
    let lease = UILabel()
    let sublease = UILabel()
    let findARoommate = UILabel()
    let titleLabelText = ["Real Estate", "Lease", "Sublease", "Find Roommates"]
    lazy var titleLabels: [UILabel] = [realEstate, lease, sublease, findARoommate]
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        createTitleViews()
    }
    fileprivate func createTitleViews() {
        for (index, title) in titleLabels.enumerated() {
            title.text = titleLabelText[index]
            title.isUserInteractionEnabled = true
            title.numberOfLines = 1
            title.adjustsFontSizeToFitWidth = true
            title.textColor = defaultColor
            title.tag = index
            let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(titleLabelClicked))
            title.addGestureRecognizer(tapGuesture)
        }
        realEstate.textColor = selectedColor
        let titleStackView = UIStackView(arrangedSubviews: titleLabels)
        self.addSubview(titleStackView)
        titleStackView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: leftRightPadding, paddingBottom: 0, paddingRight: leftRightPadding, width: 0, height: ZJRentApiListTopSettingView.selfHeight/2)
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fillProportionally
        titleStackView.spacing = 20
    }
    
    @objc fileprivate func titleLabelClicked(sender: UITapGestureRecognizer) {
        for (index, title) in titleLabels.enumerated() {
            title.textColor = (sender.view?.tag == index) ? selectedColor : defaultColor
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
