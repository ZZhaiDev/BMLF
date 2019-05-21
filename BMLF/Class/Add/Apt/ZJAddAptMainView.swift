//
//  ZJAddAptMainView.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/17/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

//var mainViewHeightConstraint: NSLayoutConstraint?



private let cellId = "cellId"
private let dateCellId = "dateCellId"
private let headerCellId = "hearCellId"
class ZJAddAptMainView: UIView {
    fileprivate lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        cv.register(ZJAddAptDateCell.self, forCellWithReuseIdentifier: dateCellId)
//        cv.register(ZJAddAptMapView.self, forCellWithReuseIdentifier: mapViewCellId)
        cv.register(ZJAddAptHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
        cv.backgroundColor = UIColor.clear
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    fileprivate lazy var mapView: ZJAddAptMapView = {
//        let mv = ZJAddAptMapView(frame: CGRect(x: 0, y: -250, width: zjScreenWidth, height: originalMapViewH))
        let mv = ZJAddAptMapView()
        return mv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
//        self.addSubview(mapView)
//        mapView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 50, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        self.addSubview(mapView)
        mapView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 50, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        self.addSubview(collectionView)
        collectionView.anchor(top: mapView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: -200, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        collectionView.fillSuperview()
        collectionView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
//        collectionView.contentOffset = CGPoint(x: 0, y: -150)
        
        
        
//        collectionView.addSubview(mapView)
//        mapView.anchor(top: nil, left: collectionView.leftAnchor, bottom: collectionView.topAnchor, right: collectionView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: originalMapViewH)
        
//        collectionView.anchor(top: mapView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 500)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10

    }
    
}

extension ZJAddAptMainView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0{
//            return 1
//        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let dateCell = collectionView.dequeueReusableCell(withReuseIdentifier: dateCellId, for: indexPath) as! ZJAddAptDateCell
            dateCell.backgroundColor = .white
            return dateCell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as! ZJAddAptHeaderView
        if indexPath.section ==  0{
            headerView.labelText.text = "日期"
        }else{
            headerView.labelText.text = "123"
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width: zjScreenWidth, height: 88)
        }
        return CGSize(width: zjScreenWidth, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: zjScreenWidth, height: 25)
    }
    
    
    
}


