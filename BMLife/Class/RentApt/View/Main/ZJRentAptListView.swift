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

class ZJRentAptListView: UIView {
    var data = [AddAptProperties]() {
        didSet {
            collectionView.reloadData()
        }
    }

    fileprivate lazy var collectionView: UICollectionView = {
//         = UICollectionView(collectionViewLayout: UICollectionViewFlowLayout())
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.background
        return view
    }()

//    fileprivate lazy var orangeView: UIView = {
//       let view = UIView(frame: CGRect(x: 0, y: 0, width: zjScreenWidth, height: 200))
//        view.backgroundColor = .orange
//        return view
//    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .red
//        self.addSubview(orangeView)
        self.addSubview(collectionView)
        collectionView.fillSuperview()

        collectionView.dataSource = self
        collectionView.delegate = self
//        collectionView.isPagingEnabled = true
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(UINib(nibName: "ZJRentAptListViewCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        collectionView.register(UINib(nibName: "ZJRentAptListViewCell2", bundle: nil), forCellWithReuseIdentifier: cellId)

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.scrollDirection = .horizontal
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ZJRentAptListViewCell2
        cell.data = data[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tvc = UIApplication.topViewController() as? ZJRentAptViewController {
            let vc = ZJRentAptListDetailViewController()
            vc.data = data[indexPath.row]
//            let nvc = ZJNavigationController(rootViewController: vc)
            tvc.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
