//
//  ZJAddAptModel.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/29/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
//http://c8790638.ngrok.io/api/v1/rental/house/

struct ZJAddAptModel: Codable {
    var count: Int?
    var results: AddAptResults?
}

struct AddAptResults: Codable {
    var type: String? //FeatureCollection
    var features: [AddAptFeature]?
}
struct AddAptFeature: Codable {
    var id: Int?
    var type: String?
    var geometry: AddAptGeometry?
    var properties: AddAptProperties?
}

struct AddAptGeometry: Codable {
}

//post 请求
struct AddAptProperties: Codable {
    var uuid: String?
    var category: String?
    var fulladdress: String?
    var address: String?
    var city: String?
    var state: String?
    var zipcode: String?
    var submittime: String?
    var longitude: String?
    var latitude: String?
    var videos: String?
    var date: AddAptDate?
    var description: AddAptDescription?
    var contact: AddAptContact?
    var base: AddAptBase?
    var requirement: AddAptRequirement?
    var images: [AddAptImages]?
}

struct AddAptDate: Codable {
    var starttime: String?
    var endtime: String?
}

struct AddAptDescription: Codable {
    var title: String?
    var description: String?
}

struct AddAptContact: Codable {
    var phonenumber: String?
    var email: String?
    var wechat: String?
}

struct AddAptBase: Codable {
    var price: String?
    var housetype: String?
    var roomtype: String?
    var bathroom: String?
    var parkinglot: String?
    var washingmachine: String?
    var nearby: [AddAptNearby]?
    var included: [AddAptIncluded]?

}

struct AddAptNearby: Codable {
    var nearby: String?
}

struct AddAptIncluded: Codable {
    var included: String?
}

struct AddAptRequirement: Codable {
    var leaseperiod: String?
    var gender: String?
    var cooking: String?
    var smoking: String?
    var otherrequirements: [AddAptOtherRequirement]?
}

struct AddAptOtherRequirement: Codable {
    var otherrequirement: String?
}

struct AddAptImages: Codable {
    var image: String?
}
