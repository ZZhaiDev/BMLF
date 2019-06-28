//
//  ZJRentApiListTopSettingView.swift
//  BMLife
//
//  Created by Zijia Zhai on 6/21/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import RealmSwift
import AudioToolbox.AudioServices

private let leftRightPadding: CGFloat = 15
private let defaultColor: UIColor = UIColor.gray
private let selectedColor: UIColor = UIColor.orange
private let selectedCellId = "selectedCellId"
private let cellId = "cellId"

class ZJRentApiListTopSettingView: UIView {
    
    static let selfHeight: CGFloat = 100
    fileprivate var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
        .type(.down),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    
    var titleRealmResult: Results<ZJAddAptRealmModel>?
    var lastTitleRealmResult: Results<ZJAddAptRealmModel>?
    //titleRows = 0, 1, 2
    var titleRows = 0
    var subtitleIndex = 0
    var subtitleElements = [["Ascending", "Descending"], ["Studio", "1b1b", "2b1b", "2b2b", "3b1b", "3b2b", "4b4b", "Over 4 Bedrooms"],  ["Private", "Share"], ["Free Parking", "Paid Parking", "Free Parking On Street", "No Parking"], ["Indoor Washing Machine", "Share Washing Machine"], ["Boys only", "Girls only", "both"], ["Normal Cooking", "Less Cooking", "No Cooking"], ["No Smoking", "Normal Smoking"]]
    var subTitleSelectedIndex = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
    
    // titles
    let allTitle = UILabel()
    let realEstate = UILabel()
    let leaseSublease = UILabel()
    let findARoommate = UILabel()
    let titleLabelText = ["Reset/All", "Real Estate", "Lease/Sublease", "Find Roommates"]
    let titleRealm = ["Reset/All", "Real Estate", "Leasing/Subleasing", "Find a Roommate"]
    lazy var titleLabels: [UILabel] = [allTitle, realEstate, leaseSublease, findARoommate]
    //subtitles
    let price = PaddingLabel()
    let roomType = PaddingLabel()
    let houseType = PaddingLabel()
    let bathRoom = PaddingLabel()
    let parkingLot = PaddingLabel()
    
    let washingMachine = PaddingLabel()
    let gender = PaddingLabel()
    let leasingPeriod = PaddingLabel()
    let cooking = PaddingLabel()
    let smoking = PaddingLabel()
    
    let subTitleLabelText = ["Price", "Room Type", "Bathroom", "Parking Lot", "Washing Machine", "Gender", "Cooking", "Smoking"]
    let subTitle1Realm = ["price", "roomtype", "bathroom", "parkinglot", "washingmachine", "gender", "cooking", "smoking"]
    lazy var subTitleLabels: [UILabel] = [price, roomType, bathRoom, parkingLot, washingMachine, gender, cooking, smoking]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        createTitleViews()
        createSubTitle1()
//        createSubTitle2()
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
            title.textAlignment = .center
            title.numberOfLines = 1
            title.font = UIFont.systemFont(ofSize: 12)
            title.adjustsFontSizeToFitWidth = true
            title.textColor = defaultColor
            title.tag = index
            let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(subTitleLabelClicked))
            title.addGestureRecognizer(tapGuesture)
        }
        let titleStackView = UIStackView(arrangedSubviews: [price, roomType, bathRoom, parkingLot])
        self.addSubview(titleStackView)
        titleStackView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: ZJRentApiListTopSettingView.selfHeight*2/5, paddingLeft: leftRightPadding, paddingBottom: 0, paddingRight: leftRightPadding, width: 0, height: ZJRentApiListTopSettingView.selfHeight/4)
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fillProportionally
        titleStackView.spacing = 8
        
        let titleStackView2 = UIStackView(arrangedSubviews:  [washingMachine, gender, cooking, smoking])
        self.addSubview(titleStackView2)
        titleStackView2.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: ZJRentApiListTopSettingView.selfHeight*(2/5+1/4) + 5, paddingLeft: leftRightPadding, paddingBottom: 0, paddingRight: leftRightPadding, width: 0, height: ZJRentApiListTopSettingView.selfHeight/4)
        titleStackView2.axis = .horizontal
        titleStackView2.distribution = .fillProportionally
        titleStackView2.spacing = 8
    }
    
//    fileprivate func createSubTitle2() {
//        for (index, title) in subTitleLabels2.enumerated() {
//            title.text = subTitleLabelText2[index]
//            title.layer.cornerRadius = 10
//            title.layer.masksToBounds = true
//            title.layer.borderColor = defaultColor.cgColor
//            title.layer.borderWidth = 1
//            title.isUserInteractionEnabled = true
//            title.numberOfLines = 1
//            title.font = UIFont.systemFont(ofSize: 12)
//            title.adjustsFontSizeToFitWidth = true
//            title.textColor = defaultColor
//            title.tag = index
//            let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(titleLabelClicked2))
//            title.addGestureRecognizer(tapGuesture)
//        }
//
//    }
    
    @objc fileprivate func titleLabelClicked(sender: UITapGestureRecognizer) {
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
        
        titleRows = 0
        let index = sender.view!.tag
        for (index, title) in titleLabels.enumerated() {
            title.textColor = (sender.view!.tag == index) ? selectedColor : defaultColor
        }
        guard let topVC = UIApplication.topViewController() as? ZJRentAptViewController else { return }
        if index == 0 {
            resetReaultRealm()
        } else if index == 2 {
            titleRealmResult = topVC.realmResult?.filter("category CONTAINS[c] 'Leasing' OR category CONTAINS[c] 'Subleasing'")
        }else {
            titleRealmResult = topVC.realmResult?.filter("category CONTAINS[c] '\(titleRealm[index])'")
        }
        topVC.listView.realmData = titleRealmResult
        lastTitleRealmResult = titleRealmResult
        resetFilter()
    }
    
    fileprivate func resetFilter() {
        subTitleSelectedIndex = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
        for label in subTitleLabels {
            label.textColor = defaultColor
            label.layer.borderColor = defaultColor.cgColor
        }
    }
    
    func resetReaultRealm() {
        guard let topVC = UIApplication.topViewController() as? ZJRentAptViewController else { return }
        titleRealmResult = topVC.realmResult?.sorted(byKeyPath: "id")
        lastTitleRealmResult = titleRealmResult
        resetFilter()
    }
    
    @objc fileprivate func subTitleLabelClicked(sender: UITapGestureRecognizer) {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        titleRows = 1
        subtitleIndex = sender.view!.tag
        createPopOver(index: subtitleIndex, sender: sender)
    }
    
    fileprivate func createPopOver(index: Int, sender: UITapGestureRecognizer) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: subtitleElements[index].count * 44))
        let tableView = UITableView(frame: CGRect(x: 0, y: 10, width: 200, height: subtitleElements[index].count * 44 - 10))
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
        self.popover.show(view, fromView: sender.view!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZJRentApiListTopSettingView: UITableViewDelegate {
    fileprivate func setSelectedColor(index: Int) {
        subTitleLabels[index].textColor = UIColor.orange
        subTitleLabels[index].layer.borderColor = UIColor.orange.cgColor
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        guard let topVC = UIApplication.topViewController() as? ZJRentAptViewController else { return }
        switch titleRows {
        case 0:
            break
        case 1:
            
            setSelectedColor(index: subtitleIndex)
            if subTitleSelectedIndex[subtitleIndex] != -1 {
                titleRealmResult = lastTitleRealmResult
            }
            subTitleSelectedIndex[subtitleIndex] = indexPath.row
            ZJPrint(subTitleSelectedIndex)
            for (index, value) in subTitleSelectedIndex.enumerated() {
                if value == -1 { continue }
                if index == 0 {      //price
                    let order: Bool = (value == 0) ? true : false
                    titleRealmResult = titleRealmResult?.sorted(byKeyPath: subTitle1Realm[0], ascending: order)
                } else {
                    titleRealmResult = titleRealmResult?.filter("\(subTitle1Realm[index]) CONTAINS[c] '\(subtitleElements[index][value])'")
                }
            }
            topVC.listView.realmData = titleRealmResult
        default:
            break
        }
        self.popover.dismiss()
    }
}

extension ZJRentApiListTopSettingView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return subtitleElements[subtitleIndex].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if subTitleSelectedIndex[subtitleIndex] == indexPath.row {
            let sCell = tableView.dequeueReusableCell(withIdentifier: selectedCellId, for: indexPath) as! SelectedCell
            sCell.textL.text = subtitleElements[subtitleIndex][indexPath.item]
            sCell.textL.textColor = .orange
            return sCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = subtitleElements[subtitleIndex][indexPath.item]
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
