//
//  ZJRentAptListDetainViewController.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/21/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

private let zjCycleViewH: CGFloat = zjScreenHeight * 3 / 8
private let titleViewH:CGFloat = 100
private let cateViewH: CGFloat = 90
private let zjHeaderViewH: CGFloat = 50
private let zjItemMargin : CGFloat = 10

private let cellId = "cellId"
private let headerCellId = "headerCellId"
private let baseCellId = "baseCellId"
private let requirementCellId = "requirementCellId"
class ZJRentAptListDetailViewController: ZJBaseViewController {
    
    var data = AddAptProperties(){
        didSet{
            titleView.data = data
            if let images = data.images{
                cycleView.data = images
            }
            
            
            baseValue.append(data.fullAddress ?? "")
            let price = data.base?.price ?? "" + "/m"
            baseValue.append(price)
            baseValue.append(data.base?.roomtype ?? "")
            let bathroom = data.base?.bathroom ?? "" + "Bathroom"
            baseValue.append(bathroom)
            baseValue.append(data.base?.parkinglot ?? "")
            baseValue.append(data.base?.washingmachine ?? "")
            
            if let requirement = data.requirement, let others = requirement.otherrequirements{
                for other in others{
                    requirementTitles.append(other.otherrequirement ?? "")
                }
            }
            if let base = data.base, let include = base.included{
                for i in include{
                    includeTitles.append(i.included ?? "")
                }
            }
            
            if let base = data.base, let nearby = base.nearby{
                for i in nearby{
                    closeTitles.append(i.nearby ?? "")
                }
            }
        }
    }
    
    var requiredmentCellHeight: CGFloat = 100
    var ynCategoryButtons = [YNCategoryButton]()
    
    let titleArr = ["Base", "Requirement", "Included", "Nearby", "包含", "附近"]
    var basekey = ["Address", "Price", "Type", "Bathroom", "Parking", "Washer"]
    var baseValue = [String]()
    var requirementTitles = [String]()
    var includeTitles = [String]()
    var closeTitles = [String]()
    
    let cycleView: RecommendCycleView = {
        let cv = RecommendCycleView.recommendCycleView()
        cv.frame = CGRect(x: 0, y: -(zjCycleViewH+titleViewH+cateViewH), width: zjScreenWidth, height: zjCycleViewH)
        return cv
    }()
    
    let titleView: ZJRentAptListDetailTitleView = {
       let tv = ZJRentAptListDetailTitleView(frame: CGRect(x: 0, y: -(titleViewH+cateViewH), width: zjScreenWidth, height: titleViewH))
        return tv
    }()
    
    let catView: ZJRentAptListDetailCatrgories = {
       let cat = ZJRentAptListDetailCatrgories(frame: CGRect(x: 0, y: -cateViewH, width: zjScreenWidth, height: cateViewH))
        return cat
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: zjScreenWidth, height: zjHeaderViewH)
//        layout.itemSize = CGSize(width: zjScreenWidth, height: 150)
        layout.minimumInteritemSpacing = zjItemMargin
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: zjItemMargin, bottom: 0, right: zjItemMargin)
        
        let cv = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        cv.register(ZJRentAptListDetailBaseCell.self, forCellWithReuseIdentifier: baseCellId)
        
        cv.register(ZJRentAptListDetailRequirementCell.self, forCellWithReuseIdentifier: requirementCellId)
        cv.backgroundColor = .clear
//        cv.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: zjPrettyCellID)
//        cv.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: zjNormalCellID)
        
        cv.register(ZJRentAptListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
        
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: zjCycleViewH+titleViewH+cateViewH, left: 0, bottom: 0, right: 0)
        collectionView.addSubview(cycleView)
        collectionView.addSubview(titleView)
        collectionView.addSubview(catView)
    }
}


extension ZJRentAptListDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            ZJPrint(baseValue.count)
            ZJPrint(basekey.count)
            return min(basekey.count, baseValue.count)
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width: zjScreenWidth, height: 25)
        }else if indexPath.section == 1{
            return CGSize(width: zjScreenWidth, height: calcuatedHeight(titles: requirementTitles))
        }else if indexPath.section == 2{
            return CGSize(width: zjScreenWidth, height: calcuatedHeight(titles: includeTitles))
        }else if indexPath.section == 3{
            return CGSize(width: zjScreenWidth, height: calcuatedHeight(titles: closeTitles))
        }
        return CGSize(width: zjScreenWidth, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: baseCellId, for: indexPath) as! ZJRentAptListDetailBaseCell
            
            cell.firstLabel.text = "\(basekey[indexPath.row])" + ":"
            ZJPrint(baseValue.count)
            cell.secondtLabel.text = "\(baseValue[indexPath.row])"
//            cell.firstLabel.text = "123"
//            cell.secondtLabel.text = "665"
            return cell
        }else if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: requirementCellId, for: indexPath) as! ZJRentAptListDetailRequirementCell
            cell.ynCategoryButtonType = .colorful
            cell.titles = requirementTitles
            
            return cell
        }else if indexPath.section == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: requirementCellId, for: indexPath) as! ZJRentAptListDetailRequirementCell
            cell.titles = includeTitles
            return cell
        }else if indexPath.section == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: requirementCellId, for: indexPath) as! ZJRentAptListDetailRequirementCell
            cell.titles = closeTitles
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        if indexPath.row/2 == 0{
            cell.backgroundColor = .red
        }else{
            cell.backgroundColor = .black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 1.取出HeaderView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as! ZJRentAptListHeaderView
        
        headerView.label.text = titleArr[indexPath.section]
        return headerView
    }
    
    func calcuatedHeight(titles: [String]) -> CGFloat{
        let margin: CGFloat = 15
        var formerWidth: CGFloat = 15
        var formerHeight: CGFloat = 0
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
            ynCategoryButtons.append(button)
        }
        ynCategoryButtons.removeAll()
        return formerHeight + 25
    }
    
    
    
}