//
//  CustomCalloutView.swift
//  BMLF
//
//  Created by zijia on 6/1/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import Kingfisher

class CalloutViewCell: UICollectionViewCell {
    var data = AddAptImages(){
        didSet{
            imageV.kf.indicatorType = .activity
            if let image = data.image{
                let url = URL(string: image)
                imageV.kf.setImage(with: url)
            }
            
        }
    }
    
    lazy var imageV: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageV)
        imageV.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private let cellId = "cellId"
private let phoneBHeight: CGFloat = 50
private let callStr = "Call: "

class CustomCalloutView: UIView{
    lazy var collectionView: UICollectionView = { [weak self] in
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(CalloutViewCell.self, forCellWithReuseIdentifier: cellId)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    
    
    lazy var phoneB: UIButton = {
        let b = UIButton()
        b.isUserInteractionEnabled = true
        b.backgroundColor = .orange
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        b.titleLabel?.numberOfLines = 1
        b.titleLabel?.adjustsFontSizeToFitWidth = true
        b.titleLabel?.lineBreakMode = .byClipping
        b.titleLabel?.textColor = .black
        b.addTarget(self, action: #selector(phoneBclicked), for: .touchUpInside)
        return b
    }()
    
    @objc fileprivate func phoneBclicked(){
        if let str = phoneB.titleLabel?.text, let phone = str.components(separatedBy: callStr).last, let url = URL(string: "telprompt://\(phone)"), UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url, options: [:]) { (_) in
                
            }
        }
        
    }
    @objc func onTap() {
        if let tvc = UIApplication.topViewController() as? ZJRentAptViewController{
            let vc = ZJRentAptListDetailViewController()
            vc.data = data
            //            let nvc = ZJNavigationController(rootViewController: vc)
            tvc.navigationController?.pushViewController(vc, animated: true)
        }
    }
    var data = AddAptProperties(){
        didSet{
            if let contact = data.contact, let phone = contact.phonenumber{
                let str = callStr + phone
                phoneB.setTitle(str, for: .normal)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3
        
        
        
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: phoneBHeight, paddingRight: 0, width: 0, height: 0)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: self.frame.size.width, height: self.frame.size.height-phoneBHeight)
        ZJPrint(self.frame.size.width)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        
        addSubview(phoneB)
        phoneB.anchor(top: collectionView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomCalloutView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.images?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CalloutViewCell
        if let image = data.images?[indexPath.row]{
            cell.data = image
        }
        return cell
    }
}
