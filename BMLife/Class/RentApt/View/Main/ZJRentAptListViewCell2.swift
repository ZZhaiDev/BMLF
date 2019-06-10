//
//  ZJRentAptListViewCell2.swift
//  BMLife
//
//  Created by zijia on 6/8/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import Kingfisher

class ZJRentAptListViewCell2: UICollectionViewCell {
    var data = AddAptProperties() {
        didSet {
            ZJPrint(data.fulladdress)
            if let city = data.city, let state = data.state {
                ZJPrint(city)
                cityLabel.text = city + ", " + state
            }
            if let description = data.description, let title = description.title {
                titleLabel.text = title
            }
//            if let time = data.submittime{
//                timeL.text = time
//            }

//            if let contact = data.contact{
//                if let email = contact.email{
//                    emailB.setTitle(email, for: .normal)
//                }
//                if let phone = contact.phonenumber{
//                    phoneB.setTitle(phone, for: .normal)
//                }
//            }

            if let base = data.base {
                if let price = base.price {
                    priceLabel.text = "$ \(price)/m"
                }
                if let category = data.category {
                    typeLabel.text = category
                }
//                if let nearby = base.nearby{
//                    var result = "Close to"
//                    for i in nearby{
//                        result += " \(i.nearby ?? ""),"
//                    }
//                    result.removeLast()
//                    if nearby.count == 0{
//                        result = ""
//                    }
//                    closeL.text = result
//                }
            }

//            if let requirement = data.requirement{
//                if let gender = requirement.gender{
//                    genderL.text = gender
//                }
//            }

            if let imagef = data.images?.first, let imageStr = imagef.image {
                imageV.kf.indicatorType = .activity
                ZJPrint(imageStr)
                let url = URL(string: imageStr)
                imageV.kf.setImage(with: url)

            }
        }
    }

    static let selfHeight: CGFloat = 245
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var typeLabel: PaddingLabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageV: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backView.layer.cornerRadius = 10
        backView.layer.masksToBounds = true
        backView.layer.borderWidth = 0.1
        backView.layer.borderColor = UIColor.orange.cgColor

        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true

        imageV.layer.borderColor = UIColor.init(r: 21, g: 88, b: 35).cgColor
        imageV.layer.borderWidth = 0.5

//        titleLabel.numberOfLines = 1

    }

}
