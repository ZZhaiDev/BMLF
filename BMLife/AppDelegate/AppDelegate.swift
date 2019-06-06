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
 所有表格不认识中文？
 坐标不能是string 只能是double？
 
 <NSHTTPURLResponse: 0x282eeb180> { URL: https://blissmotors-web-upload.s3.amazonaws.com/uuid-IMG_1240.JPG?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAX7JZ5S7OYYBHPMNO/20190531/us-east-1/s3/aws4_request&X-Amz-Date=20190531T031323Z&X-Amz-Expires=600&X-Amz-SignedHeaders=content-encoding;content-type;host&X-Amz-Signature=b50721364e9167622c212ad197615c39aa9bd54cd367ba907c2437611adc6a4f } { Status Code: 200, Headers {
 aws上传的图片返回数据长这样 如何截取？？ 以后会不会改变！
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

