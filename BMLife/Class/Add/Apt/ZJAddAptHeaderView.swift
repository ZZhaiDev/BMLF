//
//  ZJAddAptHeaderView.swift
//  BMLF
//
//  Created by zijia on 5/18/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class ZJAddAptHeaderView: UICollectionReusableView {

    let labelText : UILabel = {
       let lable = UILabel()
        return lable
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(labelText)
        labelText.fillSuperview(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
