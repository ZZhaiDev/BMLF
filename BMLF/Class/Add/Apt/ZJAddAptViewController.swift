//
//  ZJAddAptViewController.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/16/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class ZJAddAptViewController: ZJBaseViewController {
    fileprivate lazy var mainView : ZJAddAptMainView = {
        let mv = ZJAddAptMainView()
        return mv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closefunc))
        self.view.addSubview(mainView)
        mainView.fillSuperview()
        
    }
    
    @objc fileprivate func closefunc(){
        self.dismiss(animated: true) {
        }
    }
    

}
