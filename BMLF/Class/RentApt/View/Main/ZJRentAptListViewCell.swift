//
//  ZJRentAptListViewCell.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/17/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import Kingfisher

class ZJRentAptListViewCell: UICollectionViewCell {
    
    var data = AddAptProperties(){
        didSet{
            ZJPrint(data.fullAddress)
            if let city = data.city{
                ZJPrint(city)
                cityL.text = city
            }
            if let time = data.submittime{
                timeL.text = time
            }
            
            if let contact = data.contact{
                if let email = contact.email{
                    emailB.setTitle(email, for: .normal)
                }
                if let phone = contact.phonenumber{
                    phoneB.setTitle(phone, for: .normal)
                }
            }
            
            if let base = data.base{
                if let price = base.price{
                    priceL.text = "\(price)/m"
                }
                if let type = base.housetype{
                    typeL.text = type
                }
                if let nearby = base.nearby{
                    var result = "Close to"
                    for i in nearby{
                        result += " \(i.nearby ?? ""),"
                    }
                    result.removeLast()
                    if nearby.count == 0{
                        result = ""
                    }
                    closeL.text = result
                }
            }
            
            if let requirement = data.requirement{
                if let gender = requirement.gender{
                    genderL.text = gender
                }
            }
            
            if let imagef = data.images?.first, let imageStr = imagef.image{
                imageV.kf.indicatorType = .activity
                ZJPrint(imageStr)
                let url = URL(string: imageStr)
                imageV.kf.setImage(with: url)
                
            }
        }
    }

    @IBOutlet weak var typeL: UILabel!
    @IBOutlet weak var genderL: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var priceL: UILabel!
    @IBOutlet weak var cityL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var closeL: UILabel!
    @IBOutlet weak var emailB: UIButton!
    @IBOutlet weak var phoneB: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        
        emailB.titleLabel?.numberOfLines = 1;
        emailB.titleLabel?.adjustsFontSizeToFitWidth = true;
        emailB.titleLabel?.lineBreakMode = .byClipping
//        self.layer.cornerRadius = 15
//        self.layer.masksToBounds = true
        // Initialization code
    }

}
