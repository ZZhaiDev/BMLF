//
//  ZJTabBarController.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/16/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class ZJTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private lazy var composeBtn : UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setUpAllViewController()
        self.tabBar.tintColor = UIColor.orange
        setupComposeBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for i in 0..<tabBar.items!.count {
            // 2.获取item
            let item = tabBar.items![i]
            
            // 3.如果是下标值为2,则该item不可以和用户交互
            if i == 1 {
                item.isEnabled = false
                continue
            }
        }
        
    }
    
    private func setupComposeBtn() {
        // 1.将composeBtn添加到tabbar中
        tabBar.addSubview(composeBtn)
        
        // 2.设置属性
        composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: .normal)
        composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: .highlighted)
//        composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: .normal)
//        composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        composeBtn.setTitle("+", for: .normal)
        composeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        composeBtn.titleLabel?.textColor = .white
//        composeBtn.sizeToFit()
        composeBtn.frame.size = CGSize(width: zjScreenWidth/5, height: zjScreenWidth/5)
        
        // 3.设置位置
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.2)
        composeBtn.addTarget(self, action: #selector(composeBtnButtonClicked), for: .touchUpInside)
    }
    
    // 添加所有控件
    func setUpAllViewController() -> Void {
        setUpChildController(ZJRentAptViewController(), "房子","tabLive","tabLiveHL")
//        setUpChildController(UIViewController(), "同城",  "tabYule",  "tabYuleHL")
        setUpChildController(UIViewController(), "",  "",  "")
//        setUpChildController(UIViewController(), "移民",  "tabYuba",  "tabYubaHL")
        setUpChildController(MineViewController(), "我的",  "tabDiscovery",  "tabDiscoveryHL")
    }
    
    @objc fileprivate func composeBtnButtonClicked(){
        
        let publishView = Bundle.main.loadNibNamed("PublishView", owner: nil, options: nil)?.first as! PublishView
        
        publishView.show()
    }

    fileprivate func setUpChildController(_ controller : UIViewController,_ title : String,_ norImage : String,_ selectedImage : String){
        
        controller.tabBarItem.title = title
        controller.tabBarItem.image = UIImage(named: norImage)
        controller.tabBarItem.selectedImage = UIImage(named: selectedImage)
        // 设置 NavigationController
        let nav = ZJNavigationController(rootViewController: controller)
//        controller.title = title
        self.addChild(nav)
    }
    

}


