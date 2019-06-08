//
//  ZJRentAptListDetailContactCell.swift
//  BMLife
//
//  Created by Zijia Zhai on 6/7/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import MessageUI

private let leftPadding: CGFloat = 15
private let spacePadding: CGFloat = 10
private let topPadding: CGFloat = 0

class ZJRentAptListDetailContactCell: UICollectionViewCell {
    static let selfHeight: CGFloat = 130
    fileprivate let callStr = "Call: "
    fileprivate let emailStr = "Email: "
    var poster_email = ""
    var poster_phone = ""
    var data: AddAptContact?{
        didSet{
            guard let data = data else {return}
            if let email = data.email{
                poster_email = email
                emailB.setTitle(emailStr + email, for: .normal)
            }
            if let phone = data.phonenumber{
                poster_phone = phone
                phoneB.setTitle(callStr + phone, for: .normal)
            }
            if let weChat = data.wechat{
                wechatL.text = weChat
            }
        }
    }
    
    lazy var phoneB: UIButton = {
       let b = UIButton()
        b.backgroundColor = .orange
//        b.setTitle("Call: 654000333552", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.addTarget(self, action: #selector(callPhone), for: .touchUpInside)
        
        b.layer.cornerRadius = (ZJRentAptListDetailContactCell.selfHeight - 2*spacePadding)/3/2
        b.layer.masksToBounds = false
        b.layer.shadowColor = UIColor.lightGray.cgColor;
        b.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        b.layer.shadowOpacity = 1.0
        b.layer.shadowRadius = 0.0
        return b
    }()
    
    lazy var emailB: UIButton = {
        let b = UIButton()
        b.backgroundColor = .orange
//        b.setTitle("Email: asdfsdff@/com", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
        
        b.layer.cornerRadius = (ZJRentAptListDetailContactCell.selfHeight - 2*spacePadding)/3/2
        b.layer.masksToBounds = false
        b.layer.shadowColor = UIColor.lightGray.cgColor;
        b.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        b.layer.shadowOpacity = 1.0
        b.layer.shadowRadius = 0.0
        return b
    }()
    
    lazy var wechatL: UILabel = {
        let b = UILabel()
//        b.text = "微信：dafasdfdafs"
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackV = UIStackView(arrangedSubviews: [phoneB, emailB, wechatL])
        stackV.backgroundColor = .red
        stackV.axis = .vertical
        stackV.distribution = .fillEqually
        stackV.setCustomSpacing(spacePadding, after: phoneB)
        stackV.setCustomSpacing(spacePadding, after: emailB)
        self.addSubview(stackV)
        stackV.fillSuperview(padding: UIEdgeInsets(top: topPadding, left: leftPadding, bottom: 0, right: zjScreenWidth/3))
    }
    
    @objc fileprivate func sendEmail(){
        if MFMailComposeViewController.canSendMail() && poster_email != ""{
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([poster_email])
            //            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            mail.setSubject("BMLife-interested your post")
            if let topVC = UIApplication.topViewController(){
                topVC.present(mail, animated: true)
            }
        } else {
            // show failure alert
        }
    }
    
    @objc fileprivate func callPhone(){
        if let url = URL(string: "telprompt://\(poster_phone)"), UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [:]) { (_) in
                    
                }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ZJRentAptListDetailContactCell: MFMailComposeViewControllerDelegate{
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
