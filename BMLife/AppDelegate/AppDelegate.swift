//
//  AppDelegate.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/16/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import GoogleMaps

/*
 1. 上传数据之后 更新数据
 2. change, house, mine, draw, location icon.
 3. listdetail 界面
 4. wechat nsattributestring
 5. 地址到home 时间和距离
 6. share 到微信
 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyB-v-ac0d_I5do478BBROehAvLbltTpsGw")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        let root = ZJTabBarController()
//        let root = ZJAddAptViewController()
        self.window?.rootViewController = root
        self.window?.makeKeyAndVisible()
        UINavigationBar.appearance().tintColor = .white
        
        
        return true
    }



}

