//
//  CityBoundaryViewModel.swift
//  BMLF
//
//  Created by zijia on 5/22/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import MapKit

class CityBoundaryViewModel {
    lazy var viewModel: CityBoundaryModel = CityBoundaryModel()
}

extension CityBoundaryViewModel {
    func loadCityBoundary(city: String, finishesCallBack: @escaping () -> Void) {
//        "https://nominatim.openstreetmap.org/search.php?q=chicago&polygon_geojson=1&format=json"
        let urlStr = "https://nominatim.openstreetmap.org/search.php?q=\(city)&polygon_geojson=1&format=json"
        NetworkTools.requestData(.get, URLString: urlStr) { (result) in
//            ZJPrint(result)
            guard let result = result as? [Dictionary<String, Any>] else {return}
            guard let firstResult = result.first else {return}
            guard let geojson = firstResult["geojson"] as? [String: Any] else {return}
            guard let coordinates = geojson["coordinates"] as? [Any] else {return}
            guard let fcoordinates = coordinates.first as? [[Double]] else {return}
            var tempCoordinates = [CLLocationCoordinate2D]()
            for arr in fcoordinates {
                let lat = arr[1]
                let lon = arr[0]
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                tempCoordinates.append(coordinate)
            }
            self.viewModel.coordinates = tempCoordinates
            finishesCallBack()
        }

    }
}
