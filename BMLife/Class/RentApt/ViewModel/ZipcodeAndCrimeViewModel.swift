//
//  ZipcodeAndCrimeViewModel.swift
//  BMLife
//
//  Created by Zijia Zhai on 6/10/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

struct ZipcodeCrimeAndCount {
    var crimeCount: Int = 0
    var coordinates = [[Double]]()
    var zipCode: String = ""
    init(count: Int, coordinates: [[Double]], zipcode: String) {
        self.crimeCount = count
        self.coordinates = coordinates
        self.zipCode = zipcode
    }
}

class ZipcodeAndCrimeViewModel {
    var datas = [ZipcodeCrimeAndCount]()
}

extension ZipcodeAndCrimeViewModel {
    func loadZipcodeAndCrime(dictValue: String, finished: @escaping () -> Void) {
        datas.removeAll()
        ZJPrint(dictValue)
        let urlStr = "\(baseAPI)api/v1/location/zipcode/areas/?page_size=50"
        NetworkTools.requestData(.post, URLString: urlStr, parameters: ["in_polygon": dictValue]) { (result) in
            guard let dict = result as? [String: Any] else { return }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {return}
            do {
                let data = try JSONDecoder().decode(ZipcodeAndCrimeModel.self, from: jsonData)
                guard let features = data.features else {return}
                ZJPrint(features)
                for feature in features {
                    guard let geometry = feature.geometry else {return}
                    guard let coordinates = geometry.coordinates else {return}
                    guard let coordinate = coordinates.first?.first else {return}
                    guard let property = feature.properties else {return}
                    ZJPrint(property.crimecount)
                    guard let crimeCount = property.crimecount else {return}
                    guard let zipcode = property.zcta5ce10 else {return}
                    let tempData = ZipcodeCrimeAndCount(count: crimeCount, coordinates: coordinate, zipcode: zipcode)
                    self.datas.append(tempData)
                }
                ZJPrint(self.datas)
            } catch let jsonError {
                ZJPrint(jsonError)
            }
            finished()
        }
    }
}
