//
//  ZJAddViewController.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/16/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class ZJAddViewController: ZJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closefunc))
        
        let publishView = Bundle.main.loadNibNamed("PublishView", owner: nil, options: nil)?.first as! PublishView
        
        publishView.show()
    }
    
    @objc fileprivate func closefunc(){
        self.dismiss(animated: true) {
        }
    }
    

}
