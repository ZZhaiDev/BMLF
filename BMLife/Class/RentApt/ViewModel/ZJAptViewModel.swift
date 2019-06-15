//
//  ZJAptViewModel.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/31/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

let baseAPI = "http://api.qubeimei.com/"

class ZJAptViewModel {
    lazy var aptModel: ZJAddAptModel = ZJAddAptModel()
    lazy var aptProperties: [AddAptProperties] = [AddAptProperties]()
    static let pageSize = 300
}

extension ZJAptViewModel {
    func loadApt(page: Int = 1, pageSize: Int = ZJAptViewModel.pageSize, city: String = "", finished: @escaping ([String: Any]) -> Void) {
        ZJPrint("--------------1111111111")
        
        let api = "\(baseAPI)api/v1/rental/house/?page=\(page)&page_size=\(pageSize)&city=\(city)"
        NetworkTools.requestData(.get, URLString: api) { (responce) in
            self.aptProperties.removeAll()
            ZJPrint("--------------11111111112")
            guard let dict = responce as? [String: Any] else { return }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                return
            }
            do {
                let data = try JSONDecoder().decode(ZJAddAptModel.self, from: jsonData)
                self.aptModel = data
                guard let results = data.results else {return}
                guard let features = results.features else {return}
                for feature in features {
                    guard let properties = feature.properties else {return}
                    self.aptProperties.append(properties)
                }
            } catch let jsonError {
                ZJPrint(jsonError)
            }
            finished(responce as! [String : Any])
        }
    }
    
    func loadAptByUUID(UUID: String, finished: @escaping (AddAptProperties) -> Void) {
        let api = "\(baseAPI)api/v1/rental/house/\(UUID)"
        ZJPrint(UUID)
        ZJPrint(api)
        NetworkTools.requestData(.get, URLString: api) { (responce) in
            self.aptProperties.removeAll()
            ZJPrint("--------------11111111112")
            guard let dict = responce as? [String: Any] else { return }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                return
            }
            do {
                let data = try JSONDecoder().decode(AddAptFeature.self, from: jsonData)
                ZJPrint(data)
                guard let property = data.properties else { return }
                finished(property)
            } catch let jsonError {
                ZJPrint(jsonError)
            }
            // 这里需要做error
        }
    }
}
