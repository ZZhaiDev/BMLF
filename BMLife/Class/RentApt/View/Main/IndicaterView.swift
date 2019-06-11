//
//  indicaterView.swift
//  BMLife
//
//  Created by Zijia Zhai on 6/11/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class IndicaterView: UIView {
    static let selfWidth: CGFloat = 60
    static let selfHeight: CGFloat = 124
    var startY: CGFloat = 12
    let width: CGFloat = 10
    let height : CGFloat = 10
    let safeL: UILabel = {
       let label = UILabel(frame: .zero)
        label.text = "Safe"
        label.textColor = UIColor.dangerouseLevelColorArr[0]
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    let dangerousL: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Dangerous"
        label.textColor = UIColor.dangerouseLevelColorArr[9]
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        for index in 0...9 {
            let view = UIView(frame: CGRect(x: IndicaterView.selfWidth/2 - width/2, y: startY, width: width, height: height))
            view.backgroundColor = UIColor.dangerouseLevelColorArr[index]
            self.addSubview(view)
            startY += height
        }
        self.addSubview(safeL)
        safeL.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 12)
        self.addSubview(dangerousL)
        dangerousL.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 12)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
