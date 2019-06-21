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
    // titles
    let allTitle = UILabel()
    let realEstate = UILabel()
    let lease = UILabel()
    let sublease = UILabel()
    let findARoommate = UILabel()
    let titleLabelText = ["All", "Real Estate", "Lease", "Sublease", "Find Roommates"]
    lazy var titleLabels: [UILabel] = [allTitle, realEstate, lease, sublease, findARoommate]
    //subtitles1
    let price = PaddingLabel()
    let roomType = PaddingLabel()
    let houseType = PaddingLabel()
    let bathRoom = PaddingLabel()
    let parkingLot = PaddingLabel()
    let subTitleLabelText = ["Price", "Room Type", "House Type", "Bathroom", "Parking Lot"]
    lazy var subTitleLabels: [UILabel] = [price, roomType, houseType, bathRoom, parkingLot]
    //subtitles2
    let washingMachine = PaddingLabel()
    let gender = PaddingLabel()
    let leasingPeriod = PaddingLabel()
    let cooking = PaddingLabel()
    let smoking = PaddingLabel()
    let subTitleLabelText2 = ["Washing Machine", "Gender", "Leasing Period", "Cooking", "Smoking"]
    lazy var subTitleLabels2: [UILabel] = [washingMachine, gender, leasingPeriod, cooking, smoking]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        createTitleViews()
        createSubTitle1()
        createSubTitle2()
    }
    fileprivate func createTitleViews() {
        for (index, title) in titleLabels.enumerated() {
            title.text = titleLabelText[index]
            title.isUserInteractionEnabled = true
            title.numberOfLines = 1
            title.font = UIFont.boldSystemFont(ofSize: 20)
            title.adjustsFontSizeToFitWidth = true
            title.textColor = defaultColor
            title.tag = index
            let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(titleLabelClicked))
            title.addGestureRecognizer(tapGuesture)
        }
        allTitle.textColor = selectedColor
        let titleStackView = UIStackView(arrangedSubviews: titleLabels)
        self.addSubview(titleStackView)
        titleStackView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: leftRightPadding, paddingBottom: 0, paddingRight: leftRightPadding, width: 0, height: ZJRentApiListTopSettingView.selfHeight*2/5)
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fillProportionally
        titleStackView.spacing = 15
    }
    
    fileprivate func createSubTitle1() {
        for (index, title) in subTitleLabels.enumerated() {
            title.text = subTitleLabelText[index]
            title.layer.cornerRadius = 10
            title.layer.masksToBounds = true
            title.layer.borderColor = defaultColor.cgColor
            title.layer.borderWidth = 1
            title.isUserInteractionEnabled = true
            title.numberOfLines = 1
            title.font = UIFont.systemFont(ofSize: 12)
            title.adjustsFontSizeToFitWidth = true
            title.textColor = defaultColor
            title.tag = index
//            let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(titleLabelClicked))
//            title.addGestureRecognizer(tapGuesture)
        }
        let titleStackView = UIStackView(arrangedSubviews: subTitleLabels)
        self.addSubview(titleStackView)
        titleStackView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: ZJRentApiListTopSettingView.selfHeight*2/5, paddingLeft: leftRightPadding, paddingBottom: 0, paddingRight: leftRightPadding, width: 0, height: ZJRentApiListTopSettingView.selfHeight/4)
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fillProportionally
        titleStackView.spacing = 8
    }
    
    fileprivate func createSubTitle2() {
        for (index, title) in subTitleLabels2.enumerated() {
            title.text = subTitleLabelText2[index]
            title.layer.cornerRadius = 10
            title.layer.masksToBounds = true
            title.layer.borderColor = defaultColor.cgColor
            title.layer.borderWidth = 1
            title.isUserInteractionEnabled = true
            title.numberOfLines = 1
            title.font = UIFont.systemFont(ofSize: 12)
            title.adjustsFontSizeToFitWidth = true
            title.textColor = defaultColor
            title.tag = index
            //            let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(titleLabelClicked))
            //            title.addGestureRecognizer(tapGuesture)
        }
        let titleStackView = UIStackView(arrangedSubviews: subTitleLabels2)
        self.addSubview(titleStackView)
        titleStackView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: ZJRentApiListTopSettingView.selfHeight*(2/5+1/4) + 5, paddingLeft: leftRightPadding, paddingBottom: 0, paddingRight: leftRightPadding, width: 0, height: ZJRentApiListTopSettingView.selfHeight/4)
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fillProportionally
        titleStackView.spacing = 8
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
