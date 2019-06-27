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
private let selectedCellId = "selectedCellId"
private let cellId = "cellId"

class ZJRentApiListTopSettingView: UIView {
    
    static let selfHeight: CGFloat = 100
    fileprivate var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
        .type(.down),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
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
    let subTitle1Realm = ["price", "roomtype", "housetype", "bathroom", "parkinglot"]
    lazy var subTitleLabels: [UILabel] = [price, roomType, houseType, bathRoom, parkingLot]
    //subtitles2
    let washingMachine = PaddingLabel()
    let gender = PaddingLabel()
    let leasingPeriod = PaddingLabel()
    let cooking = PaddingLabel()
    let smoking = PaddingLabel()
    let subTitleLabelText2 = ["Washing Machine", "Gender", "Leasing Period", "Cooking", "Smoking"]
    let subTitle2Realm = ["washingmachine", "gender", "leasingperiod", "cooking", "smoking"]
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
            let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(titleLabelClicked1))
            title.addGestureRecognizer(tapGuesture)
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
        titleRows = 0
        for (index, title) in titleLabels.enumerated() {
            title.textColor = (sender.view!.tag == index) ? selectedColor : defaultColor
        }
        guard let topVC = UIApplication.topViewController() as? ZJRentAptViewController else { return }
        topVC.listView.realmData = realmInstance.objects(ZJAddAptRealmModel.self).sorted(byKeyPath: "price")
    }
    
    @objc fileprivate func titleLabelClicked1(sender: UITapGestureRecognizer) {
        titleRows = 1
//        for (index, title) in subTitleLabels.enumerated() {
//            title.textColor = (sender.view!.tag == index) ? selectedColor : defaultColor
//            title.layer.borderColor = title.textColor.cgColor
//        }
        let selectedLabel = sender.view as! UILabel
        selectedLabel.textColor = selectedColor
        selectedLabel.layer.borderColor = selectedColor.cgColor
        subtitle1Index = sender.view!.tag
//        guard let topVC = UIApplication.topViewController() as? ZJRentAptViewController else { return }
//        topVC.listView.realmData = realmInstance.objects(ZJAddAptRealmModel.self).sorted(byKeyPath: "price")
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: subtitle1elements[subtitle1Index].count * 44))
        let tableView = UITableView(frame: CGRect(x: 0, y: 10, width: 200, height: subtitle1elements[subtitle1Index].count * 44 - 10))
        tableView.rowHeight = 44.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(SelectedCell.self, forCellReuseIdentifier: selectedCellId)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        self.popover = Popover(options: self.popoverOptions)
        self.popover.willShowHandler = {
            print("willShowHandler")
        }
        self.popover.didShowHandler = {
            print("didDismissHandler")
        }
        self.popover.willDismissHandler = {
            print("willDismissHandler")
        }
        self.popover.didDismissHandler = {
            print("didDismissHandler")
        }
        self.popover.show(view, fromView: sender.view!)
    }
    
    @objc fileprivate func titleLabelClicked2(sender: UITapGestureRecognizer) {
        titleRows = 2
        for (index, title) in titleLabels.enumerated() {
            title.textColor = (sender.view?.tag == index) ? selectedColor : defaultColor
        }
        guard let topVC = UIApplication.topViewController() as? ZJRentAptViewController else { return }
        topVC.listView.realmData = realmInstance.objects(ZJAddAptRealmModel.self).sorted(byKeyPath: "price")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZJRentApiListTopSettingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let topVC = UIApplication.topViewController() as? ZJRentAptViewController else { return }
        switch titleRows {
        case 0:
            break
        case 1:
            switch subtitle1Index {
            case 0:
                //price
                if indexPath.row == 0 {
                    topVC.listView.realmData = realmInstance.objects(ZJAddAptRealmModel.self).sorted(byKeyPath: subTitle1Realm[0], ascending: true)
                    subTitle1SelectedIndex[0] = 0
                } else {
                    topVC.listView.realmData = realmInstance.objects(ZJAddAptRealmModel.self).sorted(byKeyPath: subTitle1Realm[0], ascending: false)
                    subTitle1SelectedIndex[0] = 1
                }
            case 1: //room type
                let tempIndex = 1
                topVC.listView.realmData = realmInstance.objects(ZJAddAptRealmModel.self).filter("\(subTitle1Realm[tempIndex]) CONTAINS[c] '\(subtitle1elements[subtitle1Index][indexPath.row])'")
                subTitle1SelectedIndex[tempIndex] = indexPath.row
            case 2:
                let tempIndex = 2
                topVC.listView.realmData = realmInstance.objects(ZJAddAptRealmModel.self).filter("\(subTitle1Realm[tempIndex]) CONTAINS[c] '\(subtitle1elements[subtitle1Index][indexPath.row])'")
                subTitle1SelectedIndex[tempIndex] = indexPath.row
            case 3:
                let tempIndex = 3
                topVC.listView.realmData = realmInstance.objects(ZJAddAptRealmModel.self).filter("\(subTitle1Realm[tempIndex]) CONTAINS[c] '\(subtitle1elements[subtitle1Index][indexPath.row])'")
                subTitle1SelectedIndex[tempIndex] = indexPath.row
            case 4:
                let tempIndex = 4
                topVC.listView.realmData = realmInstance.objects(ZJAddAptRealmModel.self).filter("\(subTitle1Realm[tempIndex]) CONTAINS[c] '\(subtitle1elements[subtitle1Index][indexPath.row])'")
                subTitle1SelectedIndex[tempIndex] = indexPath.row
            default:
                break
            }
        case 2:
            break
        default:
            break
        }
        self.popover.dismiss()
    }
}

//titleRows = 0, 1, 2
var titleRows = 0
var subtitle1Index = 0
var subtitle1elements = [["Ascending", "Descending"], ["Studio", "1b1b", "2b1b", "2b2b", "3b1b", "3b2b", "4b4b", "Over 4 Bedrooms"], ["Apartment", "Condo", "House", "Town House"], ["Private", "Share"], ["Free Parking", "Paid Parking", "Free Parking On Street", "No Parking"]]
var subTitle1SelectedIndex = [-1, -1, -1, -1, -1]
//fileprivate var texts = ["Edit", "Delete", "Report"]

extension ZJRentApiListTopSettingView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return subtitle1elements[subtitle1Index].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if subTitle1SelectedIndex[subtitle1Index] == indexPath.row {
            let sCell = tableView.dequeueReusableCell(withIdentifier: selectedCellId, for: indexPath) as! SelectedCell
            sCell.textL.text = subtitle1elements[subtitle1Index][indexPath.item]
            sCell.textL.textColor = .orange
            return sCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = subtitle1elements[subtitle1Index][indexPath.item]
        return cell
    }
}


class SelectedCell: UITableViewCell {
    var textL: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .orange
        return label
    }()
    
    var dotLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .orange
        label.text = "·"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: cellId)
        addSubview(textL)
        addSubview(dotLabel)
        self.textL.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: self.frame.size.width/8, width: 0, height: 0)
        dotLabel.anchor(top: topAnchor, left: textL.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(textL)
//        addSubview(dotLabel)
//        self.textL.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: self.frame.size.width/4, width: 0, height: 0)
//        dotLabel.anchor(top: topAnchor, left: textL.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
