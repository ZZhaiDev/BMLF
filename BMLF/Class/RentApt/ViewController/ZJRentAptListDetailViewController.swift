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
    
    var requiredmentCellHeight: CGFloat = 100
    var ynCategoryButtons = [YNCategoryButton]()
    
    let dict = [["key": "地址", "value": "160 E Grand Ave, Chicago, 60611, United States"], ["key": "价格", "value": "900/m"],["key": "房型", "value": "一室一厅"], ["key": "卫生间", "value": "share"], ["key": "停车位", "value": "免费停车位"], ["key": "洗衣机", "value": "室内洗衣机"]]
    let titleArr = ["基础", "要求", "包含", "附近", "包含", "附近"]
    let requirementTitles = ["长租", "女生", "少做饭", "禁止吸烟", "单身", "禁止养动物", "干净卫生", "长租", "女生", "少做饭", "禁止吸烟", "单身", "禁止养动物", "干净卫生"]
    let includeTitles = ["包水", "包网络", "家具", "健身房"]
    let closeTitles = ["学校","超市","地铁","bus","图书馆"]
    
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
//        self.view.addSubview(cycleView)
//        self.view.addSubview(titleView)
//        self.view.addSubview(catView)
        view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: zjCycleViewH+titleViewH+cateViewH, left: 0, bottom: 0, right: 0)
        collectionView.addSubview(cycleView)
        collectionView.addSubview(titleView)
        collectionView.addSubview(catView)

        // Do any additional setup after loading the view.
    }
    


}


extension ZJRentAptListDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return dict.count
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
            let dicts = dict[indexPath.row]
            cell.firstLabel.text = "\(dicts["key"]!)" + ":"
            cell.secondtLabel.text = "\(dicts["value"]!)"
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
