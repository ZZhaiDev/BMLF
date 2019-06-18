//
//  MyCustomUIView.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/28/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class MyCustomUIView: UIView {

    static let cellHeight: CGFloat = 120
    lazy var label: UILabel = {
       let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 18)
        lable.textAlignment = .left
        lable.text = "Description"
        return lable
    }()
    
    lazy var textView: UITextView = {
       let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.text = "(Optional)"
        tv.textColor = UIColor.lightGray
        tv.delegate = self
        return tv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        let padding:CGFloat = 18.0
        label.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 20)
        self.addSubview(textView)
        textView.anchor(top: label.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: padding, width: 0, height: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyCustomUIView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        label.textColor = UIColor.blue
        if (textView.text == "(Optional)") {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        textView.becomeFirstResponder()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        label.textColor = .black
        if (textView.text == "") {
            textView.text = "(Optional)"
            textView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
        ZJPrint(textView.text)
        descriptionText_ = textView.text
    }

}
