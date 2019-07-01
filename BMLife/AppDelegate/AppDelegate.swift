//
//  AppDelegate.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/16/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift
/*
 4. wechat nsattributestring
 6. share 到微信
 7. 首次进入app， 正在请求数据， 如果进入后台， 则请求取消， 导致没有数据了
 */
import RealmSwift
import FBSDKCoreKit
import FBSDKLoginKit

var realmInstance = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // google
        GMSServices.provideAPIKey("AIzaSyB-v-ac0d_I5do478BBROehAvLbltTpsGw")
        // facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        // window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        let root = ZJTabBarController()
        self.window?.makeKeyAndVisible()
        UINavigationBar.appearance().tintColor = .white
        self.window?.rootViewController = root
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // facebook
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // facebook
        AppEvents.activateApp()
    }
    

}
