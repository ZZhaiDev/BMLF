//
//  CycleCell.swift
//  live-streaming-demo
//
//  Created by Zijia Zhai on 1/16/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import UIKit
import Kingfisher

class CycleCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var data = AddAptImages() {
        didSet {
            imageView.kf.indicatorType = .activity
            if let imageStr = data.image {
                let url = URL(string: imageStr)
                imageView.kf.setImage(with: url)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
