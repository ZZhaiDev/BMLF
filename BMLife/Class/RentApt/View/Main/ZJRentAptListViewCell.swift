//
//  ZJRentAptListViewCell.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/17/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import Kingfisher
import MessageUI

class ZJRentAptListViewCell: UICollectionViewCell {
    
    static var selfHeight: CGFloat = 420
    
    var data = AddAptProperties(){
        didSet{
            ZJPrint(data.fulladdress)
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
    
    @IBOutlet weak var firstViewRow: UIView!
    @IBOutlet weak var secondViewRow: UIView!
    @IBOutlet weak var thirdViewRow: UIView!
    @IBOutlet weak var fourthViewRow: UIView!
    
    
    @IBAction func emailClicked(_ sender: Any) {
        sendEmail()
    }
    @IBAction func phoneClicked(_ sender: Any) {
        if let str = phoneB.titleLabel?.text, let url = URL(string: "telprompt://\(str)"), UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:]) { (_) in
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        
        emailB.titleLabel?.numberOfLines = 1;
        emailB.titleLabel?.adjustsFontSizeToFitWidth = true;
        emailB.titleLabel?.lineBreakMode = .byClipping
        
        firstViewRow.backgroundColor = UIColor.black
        secondViewRow.backgroundColor = UIColor.black
        thirdViewRow.backgroundColor = UIColor.black
        fourthViewRow.backgroundColor = UIColor.black
    }
    
    @objc fileprivate func sendEmail(){
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([emailB.titleLabel?.text ?? ""])
            //            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            mail.setSubject("BMLife-interested your post")
            if let topVC = UIApplication.topViewController(){
                topVC.present(mail, animated: true)
            }
        } else {
            // show failure alert
        }
    }

}


extension ZJRentAptListViewCell: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            if result == .sent{
                guard let topVC = UIApplication.topViewController() else {return}
                let alertVC = UIAlertController(title: "Email Sent", message: "Thanks for Your Interesting!", preferredStyle: .actionSheet)
                let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                }
                alertVC.addAction(okAction)
                topVC.present(alertVC, animated: true) {
                }
            }else{
                
            }
        }
    }
}
