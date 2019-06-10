//
//  ZJRentAptListHeaderView.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/21/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class ZJRentAptListHeaderView: UICollectionReusableView {
     lazy var label: UILabel = {
       let label = UILabel()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        label.fillSuperview(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
