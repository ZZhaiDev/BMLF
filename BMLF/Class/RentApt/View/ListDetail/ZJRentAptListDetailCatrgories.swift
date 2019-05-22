//
//  ZJRentAptListDetailCatrgories.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/21/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

private let cellId = "cellId"
private let zjEdgeInsetMargin : CGFloat = 10

class ZJRentAptListDetailCatrgories: UIView {
    
    var dict = [["crime", "crime"],["email", "street view"],["email", "other"],["crime", "crime"],["phone", "street view"],["crime", "other"],["phone", "crime"],["crime", "street view"],["crime", "other"]]
    
    
    fileprivate lazy var collectionView: UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: self!.frame.size.height)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: self!.bounds, collectionViewLayout: layout)
        cv.dataSource = self
        cv.register(GameCell.self, forCellWithReuseIdentifier: cellId)
        cv.contentInset = UIEdgeInsets(top: 0, left: zjEdgeInsetMargin, bottom: 0, right: zjEdgeInsetMargin)
        cv.backgroundColor = .clear
        return cv
        }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
        self.addSubview(collectionView)
    }
}

extension ZJRentAptListDetailCatrgories: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dict.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GameCell
        
//        cell.baseGame = groups![(indexPath as NSIndexPath).item]
        ZJPrint(dict[indexPath.row][0])
//        cell.imageView = UIImageView(image: UIImage(named: dict[indexPath.row][0]))
//        cell.titleView.text = dict[indexPath.row][1]
        cell.data = [dict[indexPath.row][0], dict[indexPath.row][1]]
        
        return cell
    }
}


//cell 宽高：80*90 imageView: 45*45
class GameCell: UICollectionViewCell {
    var data = [String](){
        didSet{
            imageView = UIImageView(image: UIImage(named: data[0]))
            titleView.text = data[1]
            setupUI()
        }
        
    }
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    lazy var titleView: UILabel = {
        let tv = UILabel()
        tv.textAlignment = .center
        tv.font = UIFont.systemFont(ofSize: 12)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupUI()
    }
    
    func setupUI(){
        imageView.layer.cornerRadius = 22.5
        imageView.layer.masksToBounds = true
        
        self.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -8).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        //        imageView.frame.size = CGSize(width: 45, height: 45)
        imageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 45, height: 45)
        
        self.addSubview(titleView)
        titleView.anchor(top: imageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        titleView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

   
    
}
