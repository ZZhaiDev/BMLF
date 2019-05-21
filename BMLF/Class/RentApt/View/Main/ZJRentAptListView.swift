//
//  ZJRentAptListView.swift
//  BMLF
//
//  Created by zijia on 5/16/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
private let cellId = "cellId"

class ZJRentAptListView: UIView {
    
    fileprivate lazy var collectionView: UICollectionView = {
//         = UICollectionView(collectionViewLayout: UICollectionViewFlowLayout())
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor.background
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .red
        self.addSubview(collectionView)
        collectionView.fillSuperview()
        
        collectionView.dataSource = self
        collectionView.delegate = self
//        collectionView.isPagingEnabled = true
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(UINib(nibName: "ZJRentAptListViewCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: zjScreenWidth, height: 320)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ZJRentAptListView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ZJRentAptListViewCell

//        cell.backgroundColor = .yellow
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tvc = UIApplication.topViewController() as? ZJRentAptViewController{
            let vc = ZJRentAptListDetailViewController()
//            let nvc = ZJNavigationController(rootViewController: vc)
            tvc.navigationController?.pushViewController(vc, animated: true)
            
            
        }
    }
    
    
    
    
    
    
}
