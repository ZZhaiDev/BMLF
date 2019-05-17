//
//  ZJAddAptMainView.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/17/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class ZJAddAptMainView: UIView {
    fileprivate lazy var mapView: ZJAddAptMapView = {
        let mv = ZJAddAptMapView(frame: CGRect(x: 10, y: 10, width: zjScreenWidth-20, height: 100))
        return mv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mapView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
