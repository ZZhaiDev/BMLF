//
//  ZJAptViewModel.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/31/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class ZJAptViewModel{
    lazy var aptModel: ZJAddAptModel = ZJAddAptModel()
    lazy var aptProperties: [AddAptProperties] = [AddAptProperties]()
}

extension ZJAptViewModel{
    func loadApt(finished: @escaping ([String: Any])->()){
        let api = "http://aca33a60.ngrok.io/api/v1/rental/house/"
        NetworkTools.requestData(.get, URLString: api) { (responce) in
            
            guard let dict = responce as? [String: Any] else { return }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else{
                return
            }
            do {
                let data = try JSONDecoder().decode(ZJAddAptModel.self, from: jsonData)
                self.aptModel = data
                guard let results = data.results else {return}
                guard let features = results.features else {return}
                for feature in features{
                    guard let properties = feature.properties else {return}
                    self.aptProperties.append(properties)
                }
//                ZJPrint(self.aptProperties.count)
//                ZJPrint(self.aptProperties)
                
            } catch let jsonError {
                ZJPrint(jsonError)
            }

            
            
            finished(responce as! [String : Any])
        }
    }
}

