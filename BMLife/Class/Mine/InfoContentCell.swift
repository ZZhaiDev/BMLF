//
//  InfoContentCell.swift
//  find-my-parking
//
//  Created by Tieda Wei on 2019-04-21.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import UIKit
import MessageUI

class InfoContentCell: UICollectionViewCell {

    let title1 = UILabel()
    let title2 = UILabel()
    let content1 = UILabel()
    let icon = UIImageView()
    let labelStack = UIStackView()
    let content2 = UILabel()
    let zijiaEmail = "zijiazhai@gmail.com"
    let hongleiEmail = "nbhlzhou@gmail.com"
    lazy var emailL1: PaddingLabel = {
        let email = PaddingLabel()
        email.layer.cornerRadius = 10
        email.layer.masksToBounds = true
        email.layer.borderWidth = 1
        email.layer.borderColor = UIColor.orange.cgColor
        email.text = zijiaEmail
        email.textColor = .orange
        email.font = UIFont.systemFont(ofSize: 20)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sendEmail))
        email.addGestureRecognizer(gesture)
        email.isUserInteractionEnabled = true
        return email
    }()
//    "nbhlzhou@gmail.com"
    lazy var emailL2: PaddingLabel = {
        let email = PaddingLabel()
        email.layer.cornerRadius = 10
        email.layer.masksToBounds = true
        email.layer.borderWidth = 1
        email.layer.borderColor = UIColor.orange.cgColor
        email.text = hongleiEmail
        email.textColor = .orange
        email.font = UIFont.systemFont(ofSize: 20)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sendEmail))
        email.addGestureRecognizer(gesture)
        email.isUserInteractionEnabled = true
        return email
    }()

    @objc fileprivate func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([zijiaEmail, hongleiEmail])
            mail.setSubject("BMLife-Feedback")
            if let topVC = UIApplication.topViewController() {
                topVC.present(mail, animated: true)
            }
        } else {
            // show failure alert
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        title1.textColor = .white
        title2.textColor = .white
        content1.textColor = .white
        content2.textColor = .white

        let labels = [title1, content1, title2, content2, emailL1, emailL2]
        labels.forEach { label in
            label.numberOfLines = 0
            labelStack.addArrangedSubview(label)
        }
        labelStack.spacing = 10
        labelStack.axis = .vertical
        addSubview(labelStack)
        labelStack.fillSuperview()

        title1.font = UIFont.boldSystemFont(ofSize: 32)
        title1.text = "Developers:"
        content1.text = """
        Zijia Zhai: iOS Developer😍
        Honglei Zhou: Backend Developer😍
        """
        title2.font = UIFont.boldSystemFont(ofSize: 32)
        title2.text = "Contacts:"
        content2.text = """
        If you want to report a bug, contact us;
        If you want to hire us, contact us;
        If you have any questions, contact us;
        """
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension InfoContentCell: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            if result == .sent {
                guard let topVC = UIApplication.topViewController() else {return}
                let alertVC = UIAlertController(title: "Email Sent", message: "Thanks for Your Feedback, We Will Reply back to You Soon!", preferredStyle: .actionSheet)
                let okAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
                }
                alertVC.addAction(okAction)
                topVC.present(alertVC, animated: true) {
                }
            } else {

            }
        }
    }
}

extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
