//
//  ZJRentAptListDetailCatrgories.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/21/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import MapKit

private let cellId = "cellId"
private let zjEdgeInsetMargin : CGFloat = 10

class ZJRentAptListDetailCatrgoriesCell: UICollectionViewCell {
    
    var coordinate: CLLocationCoordinate2D?
    
    var dict = [["crime", "crime"],["streetview", "street view"]]
    
    
    fileprivate lazy var collectionView: UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: self!.frame.size.height)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: self!.bounds, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(GameCell.self, forCellWithReuseIdentifier: cellId)
        cv.contentInset = UIEdgeInsets(top: 0, left: zjEdgeInsetMargin, bottom: 0, right: zjEdgeInsetMargin)
        cv.backgroundColor = .clear
        return cv
        }()
    
    lazy var line1: UIView = {
       let v = UIView(frame: .zero)
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    lazy var line2: UIView = {
        let v = UIView(frame: .zero)
        v.backgroundColor = UIColor.lightGray
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .red
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
        self.addSubview(collectionView)
        self.addSubview(line1)
        line1.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        self.addSubview(line2)
        line2.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
}

extension ZJRentAptListDetailCatrgoriesCell: UICollectionViewDataSource, UICollectionViewDelegate{
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 1{
            let streetVC = StreetViewController()
            streetVC.destinationLatitude = coordinate?.latitude
            streetVC.destinationLongitude = coordinate?.longitude
            if let topVC = UIApplication.topViewController() as? ZJRentAptListDetailViewController{
                topVC.collectionView.contentOffset.y = -(zjNavigationBarHeight+zjCycleViewH+zjStatusHeight)
                topVC.present(streetVC, animated: true) {
                    
                }
            }
        }
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
    lazy var externalView: UIView = {
        let iv = UIView()
        return iv
    }()
    
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
        externalView.layer.cornerRadius = 22.5
        externalView.layer.masksToBounds = true
        
        self.addSubview(externalView)
        externalView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -8).isActive = true
        externalView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        //        imageView.frame.size = CGSize(width: 45, height: 45)
        externalView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 45, height: 45)
        externalView.layer.borderColor = UIColor.orange.cgColor
        externalView.layer.borderWidth = 1
        
        externalView.addSubview(imageView)
        imageView.fillSuperview(padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        self.addSubview(titleView)
        titleView.anchor(top: externalView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        titleView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

   
    
}
