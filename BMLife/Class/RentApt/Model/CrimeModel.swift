//
//  Crime.swift
//  BMLife
//
//  Created by Zijia Zhai on 6/5/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

struct CrimeModel: Codable {
    var count: Int?
    var results: CrimeResultModel?
}

struct CrimeResultModel: Codable {
    var features: [CrimeFeatureModel]?
}

struct CrimeFeatureModel: Codable {
    var properties: CrimepropertiesModel?
}

struct CrimepropertiesModel: Codable {
    // swiftlint:disable identifier_name
    var address_1: String?
    var city: String?
    var state: String?
    var zip: String?
    // swiftlint:disable identifier_name
    var incident_datetime: String?
    var longitude: String?
    var latitude: String?
    // swiftlint:disable identifier_name
    var parent_incident_type: String?
}
