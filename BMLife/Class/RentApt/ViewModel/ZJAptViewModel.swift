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
    lazy var aptRealmModels: [ZJAddAptRealmModel] = [ZJAddAptRealmModel]()
    static let pageSize = 300
}

extension ZJAptViewModel {
    func loadApt(page: Int = 1, pageSize: Int = ZJAptViewModel.pageSize, city: String = "", finished: @escaping ([String: Any]) -> Void) {
        let api = "\(baseAPI)api/v1/rental/house/?page=\(page)&page_size=\(pageSize)&city=\(city)"
        NetworkTools.requestData(.get, URLString: api) { (responce) in
            self.aptProperties.removeAll()
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
                try! realmInstance.write {
                    for (_, feature) in features.enumerated() {
                        guard let properties = feature.properties else { return }
                        let realmModel = ZJAptViewModel.modelToRealm(property: properties, id: feature.id ?? -1)
                        realmInstance.add(realmModel, update: true)
                    }
                }
            } catch let jsonError {
                ZJPrint(jsonError)
            }
            finished(responce as! [String : Any])
        }
    }
    
    static func modelToRealm(property: AddAptProperties, id: Int) -> ZJAddAptRealmModel {
        let realmModel = ZJAddAptRealmModel()
        realmModel.id = id
        realmModel.uuid = property.uuid ?? ""
        realmModel.category = property.category ?? ""
        realmModel.fulladdress = property.fulladdress ?? ""
        realmModel.address = property.address ?? ""
        realmModel.city = property.city ?? ""
        realmModel.state = property.state ?? ""
        realmModel.zipcode = property.zipcode ?? ""
        realmModel.submittime = property.submittime ?? ""
        realmModel.longitude = property.longitude ?? ""
        realmModel.latitude = property.latitude ?? ""
        if let date = property.date {
            realmModel.starttime = date.starttime ?? ""
            realmModel.endtime = date.endtime ?? ""
        }
        if let description = property.description {
            realmModel.title = description.title ?? ""
            realmModel.descriptions = description.description ?? ""
        }
        if let contact = property.contact {
            realmModel.phonenumber = contact.phonenumber ?? ""
            realmModel.email = contact.email ?? ""
            realmModel.wechat = contact.wechat ?? ""
        }
        if let base = property.base {
            realmModel.price = Int(base.price ?? "0")!
            realmModel.housetype = base.housetype ?? ""
            realmModel.roomtype = base.roomtype ?? ""
            realmModel.bathroom = base.bathroom ?? ""
            realmModel.parkinglot = base.parkinglot ?? ""
            realmModel.washingmachine = base.washingmachine ?? ""
            if let nearbys = base.nearby {
                for nearby in nearbys {
                    realmModel.nearby.append(nearby.nearby ?? "")
                }
            }
            if let includeds = base.included {
                for included in includeds {
                    realmModel.included.append(included.included ?? "")
                }
            }
        }
        if let requirement = property.requirement {
            realmModel.leaseperiod = requirement.leaseperiod ?? ""
            realmModel.gender = requirement.gender ?? ""
            realmModel.cooking = requirement.cooking ?? ""
            realmModel.smoking = requirement.smoking ?? ""
            if let otherrequirements = requirement.otherrequirements {
                for otherrequirement in otherrequirements {
                    realmModel.otherrequirements.append(otherrequirement.otherrequirement ?? "")
                }
            }
        }
        if let images = property.images {
            for image in images {
                realmModel.images.append(image.image ?? "")
            }
        }
        return realmModel
    }
    
    func loadAptByUUID(UUID: String, finished: @escaping (AddAptProperties, Int) -> Void) {
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
                try! realmInstance.write {
                    let realmModel = ZJAptViewModel.modelToRealm(property: property, id: data.id ?? -1)
                    realmInstance.add(realmModel, update: true)
                }
                finished(property, data.id ?? -1)
            } catch let jsonError {
                ZJPrint(jsonError)
            }
            // 这里需要做error
        }
    }
}
