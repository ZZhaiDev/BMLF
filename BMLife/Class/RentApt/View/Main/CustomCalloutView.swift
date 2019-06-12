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
    var data = AddAptImages() {
        didSet {
            imageV.kf.indicatorType = .activity
            if let image = data.image {
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

class CustomCalloutView: UIView {
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
    
    lazy var paddingLable: PaddingLabel = {
        let lable = PaddingLabel()
        lable.textColor = UIColor.white
        lable.backgroundColor = UIColor(r: 21, g: 88, b: 35)
        return lable
    }()

    lazy var blackView: UIView = {
       let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()

    lazy var typeL: UILabel = {
       let lable = UILabel(frame: .zero)
        lable.backgroundColor = .clear
        lable.textColor = .white
        lable.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        lable.numberOfLines = 1
//        l.adjustsFontSizeToFitWidth = true
        return lable
    }()

    lazy var priceL: UILabel = {
        let lable = UILabel(frame: .zero)
        lable.backgroundColor = .clear
        lable.textColor = .white
        lable.font = UIFont.systemFont(ofSize: 15, weight: .regular)
//        l.text = "900/m"
        return lable
    }()

    lazy var requireL: UILabel = {
        let lable = UILabel(frame: .zero)
        lable.backgroundColor = .clear
        lable.textColor = .white
       lable.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        lable.numberOfLines = 0
        lable.adjustsFontSizeToFitWidth = true
        lable.textColor = UIColor.yellow.withAlphaComponent(1)
//        l.text = "Girls only"
        return lable
    }()

    lazy var emptyView: UIView  = {
       let view = UIView()
        return view
    }()

    lazy var phoneB: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = true
        button.backgroundColor = .orange
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.lineBreakMode = .byClipping
        button.titleLabel?.textColor = .black
        button.addTarget(self, action: #selector(phoneBclicked), for: .touchUpInside)
        return button
    }()

    @objc fileprivate func phoneBclicked() {
        if let str = phoneB.titleLabel?.text, let phone = str.components(separatedBy: callStr).last, let url = URL(string: "telprompt://\(phone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (_) in

            }
        }

    }
    
    @objc func onTap() {
        if let tvc = UIApplication.topViewController() as? ZJRentAptViewController {
            let detailVC = ZJRentAptListDetailViewController()
            detailVC.data = data
            tvc.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    var data = AddAptProperties() {
        didSet {
            if let contact = data.contact, let phone = contact.phonenumber {
                let str = callStr + phone
                phoneB.setTitle(str, for: .normal)
            }
            if let cat = data.category {
                paddingLable.text = cat
            }
            if let description = data.description, let title = description.title{
                typeL.text = title
            }
            if let price = data.base?.price {
                priceL.text = "Price: " + price + "/m"
            }
            var result = ""
            if let requirements = data.requirement?.otherrequirements {
                for requirement in requirements {
                    if let temp = requirement.otherrequirement {
                       result += (temp + ", ")
                    }
                }
                if let leasingP = data.requirement?.leaseperiod, leasingP != "Both"{
                    result = leasingP + ", " + result
                }
                if let cooking = data.requirement?.cooking, cooking != "Normal Cooking"{
                    result = cooking + ", " + result
                }
                if let smoking = data.requirement?.smoking, smoking == "No Smoking"{
                    result = smoking + ", " + result
                }
                if let gender = data.requirement?.gender, gender != "Both"{
                    result = gender + ", " + result
                }
                if result.suffix(2) == ", "{
                    result.removeLast(2)
                }
                requireL.text = "Requirements: " + result
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
        addSubview(paddingLable)
        paddingLable.anchor(top: collectionView.topAnchor, left: collectionView.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(blackView)
        blackView.anchor(top: nil, left: leftAnchor, bottom: collectionView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: self.frame.size.height/4)
        // swiftlint:diable force_cast
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: self.frame.size.width, height: self.frame.size.height-phoneBHeight)
        ZJPrint(self.frame.size.width)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let stackV = UIStackView(arrangedSubviews: [typeL, priceL, requireL])
        stackV.axis = .vertical
        blackView.addSubview(stackV)
        stackV.fillSuperview(padding: UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15))
        typeL.frame.size.height = stackV.frame.size.height/4
        priceL.frame.size.height = stackV.frame.size.height/4
        requireL.frame.size.height = stackV.frame.size.height/2
        addSubview(phoneB)
        phoneB.anchor(top: collectionView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomCalloutView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CalloutViewCell
        if let image = data.images?[indexPath.row] {
            cell.data = image
        }
        return cell
    }
}
