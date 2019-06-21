//
//  ZJRentAptListView.swift
//  BMLF
//
//  Created by zijia on 5/16/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
private let cellId = "cellId"
private let cellId2 = "cellId2"
private var lastContentOffset: CGFloat = -(ZJRentApiListTopSettingView.selfHeight)

class ZJRentAptListView: UIView {
    var data = [AddAptProperties]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var topSettingView: ZJRentApiListTopSettingView = {
        let view = ZJRentApiListTopSettingView(frame: .zero)
        view.backgroundColor = UIColor.background
        return view
    }()

    fileprivate lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.background
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
        collectionView.fillSuperview()
        self.addSubview(topSettingView)
        topSettingView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: ZJRentApiListTopSettingView.selfHeight)
        collectionView.contentInset = UIEdgeInsets(top: ZJRentApiListTopSettingView.selfHeight, left: 0, bottom: 0, right: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ZJRentAptListViewCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        collectionView.register(UINib(nibName: "ZJRentAptListViewCell2", bundle: nil), forCellWithReuseIdentifier: cellId)
        // swiftlint:disable force_cast
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: zjScreenWidth-20, height: ZJRentAptListViewCell2.selfHeight)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ZJRentAptListView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ZJPrint(data.count)
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ZJRentAptListViewCell2
        cell.data = data[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tvc = UIApplication.topViewController() as? ZJRentAptViewController {
            let detailVC = ZJRentAptListDetailViewController()
            detailVC.data = data[indexPath.row]
            tvc.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentY = scrollView.contentOffset.y
        ZJPrint(currentY)
        if currentY > lastContentOffset { // scroll up
            if currentY <= -(ZJRentApiListTopSettingView.selfHeight) { return }
            self.topSettingView.frame.size.height = ZJRentApiListTopSettingView.selfHeight/2 - 8
        } else {
            self.topSettingView.frame.size.height = ZJRentApiListTopSettingView.selfHeight
        }
        lastContentOffset = currentY
    }
}
