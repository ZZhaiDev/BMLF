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
private let cateViewH: CGFloat = 100
private let zjHeaderViewH: CGFloat = 50
private let zjItemMargin : CGFloat = 10

private let cellId = "cellId"
private let headerCellId = "headerCellId"
class ZJRentAptListDetailViewController: ZJBaseViewController {
    
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
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: zjItemMargin, bottom: 0, right: zjItemMargin)
        
        let cv = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
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
            return 6
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width: zjScreenWidth, height: 40)
        }
        return CGSize(width: zjScreenWidth, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        
        headerView.label.text = "基础"
        return headerView
    }
    
    
    
}
