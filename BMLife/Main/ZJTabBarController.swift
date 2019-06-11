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
        for index in 0..<tabBar.items!.count {
            let item = tabBar.items![index]
            if index == 1 {
                item.isEnabled = false
                continue
            }
        }

    }

    private func setupComposeBtn() {
        tabBar.addSubview(composeBtn)
        composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: .normal)
        composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: .highlighted)
        composeBtn.setTitle("+", for: .normal)
        composeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 45)
        composeBtn.titleLabel?.textColor = .white
        composeBtn.frame.size = CGSize(width: zjScreenWidth/5, height: tabBar.bounds.size.height)
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        composeBtn.addTarget(self, action: #selector(composeBtnButtonClicked), for: .touchUpInside)
    }

    func setUpAllViewController() {
        setUpChildController(ZJRentAptViewController(), "House","tab_house","tab_houseHL")
//        setUpChildController(UIViewController(), "同城",  "tabYule",  "tabYuleHL")
        setUpChildController(UIViewController(), "",  "",  "")
//        setUpChildController(UIViewController(), "移民",  "tabYuba",  "tabYubaHL")
        setUpChildController(InfoController(), "Mine",  "tab_mine",  "tab_mineHL")
    }

    @objc fileprivate func composeBtnButtonClicked() {
        let publishView = Bundle.main.loadNibNamed("PublishView", owner: nil, options: nil)?.first as! PublishView
        publishView.show()
    }

    fileprivate func setUpChildController(_ controller : UIViewController,_ title : String,_ norImage : String,_ selectedImage : String) {
        controller.tabBarItem.title = title
        controller.tabBarItem.image = UIImage(named: norImage)
        controller.tabBarItem.selectedImage = UIImage(named: selectedImage)
        let nav = ZJNavigationController(rootViewController: controller)
        self.addChild(nav)
    }

}
