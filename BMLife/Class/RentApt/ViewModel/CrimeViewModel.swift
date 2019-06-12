//
//  CrimeViewModel.swift
//  BMLife
//
//  Created by Zijia Zhai on 6/5/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class CrimeViewModel {
    var crimeMode = CrimeModel()
    var crimeProperties = [CrimepropertiesModel]()
}

extension CrimeViewModel {
    func loadCrime(dictValue: String, finished: @escaping () -> Void) {
        ZJPrint(dictValue)
        let urlStr = "\(baseAPI)api/v1/info/crime/il/?page_size=300"
        NetworkTools.requestData(.post, URLString: urlStr, parameters: ["in_polygon": dictValue]) { (result) in
            guard let dict = result as? [String: Any] else { return }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                return
            }
            do {
                let data = try JSONDecoder().decode(CrimeModel.self, from: jsonData)
                guard let results = data.results else {return}
                guard let features = results.features else {return}
                features.forEach({ (feature) in
                    guard let property = feature.properties else {return}
                    self.crimeProperties.append(property)
                })
            } catch let jsonError {
                ZJPrint(jsonError)
            }

            finished()
        }
    }
}
