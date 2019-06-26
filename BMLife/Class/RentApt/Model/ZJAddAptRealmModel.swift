//
//  ZJAddAptRealmModel.swift
//  BMLife
//
//  Created by zijia on 6/25/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import RealmSwift

class ZJAddAptRealmModel: Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var uuid = ""
    @objc dynamic var category = ""
    @objc dynamic var fulladdress = ""
    @objc dynamic var address = ""
    @objc dynamic var city = ""
    @objc dynamic var state = ""
    @objc dynamic var zipcode = ""
    @objc dynamic var submittime = ""
    @objc dynamic var longitude = ""
    @objc dynamic var latitude = ""
    @objc dynamic var starttime = ""
    @objc dynamic var endtime = ""
    @objc dynamic var title = ""
    @objc dynamic var descriptions = ""
    @objc dynamic var phonenumber = ""
    @objc dynamic var email = ""
    @objc dynamic var wechat = ""
    @objc dynamic var price = 0
    @objc dynamic var housetype = ""
    @objc dynamic var roomtype = ""
    @objc dynamic var bathroom = ""
    @objc dynamic var parkinglot = ""
    @objc dynamic var washingmachine = ""
    var nearby = List<String>()
    var included = List<String>()
    @objc dynamic var leaseperiod = ""
    @objc dynamic var gender = ""
    @objc dynamic var cooking = ""
    @objc dynamic var smoking = ""
    var otherrequirements = List<String>()
    var images = List<String>()
    override class func primaryKey() -> String? {
        return "id"
    }
}
