//
//  ZipcodeAndCrimeModel.swift
//  BMLife
//
//  Created by Zijia Zhai on 6/10/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

struct ZipcodeAndCrimeModel: Codable {
    var count: Int?
    var features: [ZipcodeAndCrimeModelFeature]?
}

struct ZipcodeAndCrimeModelFeature: Codable {
    var geometry: ZipcodeAndCrimeModelGeometry?
    var properties: ZipcodeAndCrimeModelProperties?
}

struct ZipcodeAndCrimeModelGeometry: Codable {
    var coordinates: [[[[Double]]]]?
}

//struct ZipcodeAndCrimeModelCoordinate: Codable{
//}

struct ZipcodeAndCrimeModelProperties: Codable {
    var zcta5ce10: String?
    var crimecount: Int?
}
