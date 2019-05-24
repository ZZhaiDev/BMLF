//
//  ZJRentAptMapView.swift
//  BMLF
//
//  Created by zijia on 5/16/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ZJRentAptMapView: UIView {
    
//    var locations = []()
    
    var isDrawing = false
    var locationManager: CLLocationManager!
    let newPin = MKPointAnnotation()
    
    var points = [CLLocationCoordinate2D]()
    
    lazy var mapsView: MKMapView = {
        let view = MKMapView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        view.delegate = self
        return view
    }()
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLocation(){
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLocation()
        setupUI()
    }
    
    fileprivate func setupUI(){
        
        self.addSubview(mapsView)
        mapsView.fillSuperview()
        
//        var coordinates = [CLLocationCoordinate2D]()
//        for location in locations{
//            coordinates.append(CLLocationCoordinate2D(latitude: location[1], longitude: location[0]))
//        }
//        let polygon = MKPolyline(coordinates: coordinates, count: locations.count)
//        mapsView.addOverlay(polygon)
    }

}

//:MARK -- 画圈
extension ZJRentAptMapView{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDrawing { return }
        mapsView.removeOverlays(mapsView.overlays)
        if let touch = touches.first {
            let coordinate = mapsView.convert(touch.location(in: mapsView),      toCoordinateFrom: mapsView)
            points.append(coordinate)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDrawing { return }
        if let touch = touches.first {
            let coordinate = mapsView.convert(touch.location(in: mapsView),       toCoordinateFrom: mapsView)
            points.append(coordinate)
            let polyline = MKPolyline(coordinates: points, count: points.count)
            mapsView.addOverlay(polyline)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDrawing { return }
        let polygon = MKPolygon(coordinates: &points, count: points.count)
        mapsView.addOverlay(polygon)
        points = [] // Reset points
    }
    
   
}

extension ZJRentAptMapView: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            if isDrawing == false{
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = UIColor.orange
                renderer.lineWidth = 3
                return renderer
            }
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .gray
            polylineRenderer.lineWidth = 1
            return polylineRenderer
        } else if overlay is MKPolygon {
            
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.fillColor = UIColor.lightGray
            return polygonView
        }
        return MKPolylineRenderer(overlay: overlay)
    }
}

extension ZJRentAptMapView: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapsView.removeAnnotation(newPin)
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapsView.setRegion(region, animated: true)
            newPin.coordinate = location.coordinate
            mapsView.addAnnotation(newPin)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation.init(latitude: location.coordinate.latitude, longitude:location.coordinate.longitude)) { (places, error) in
                if error == nil{
                    if let place = places{
                        if let firstPlace = place.first, let subthoroughfare = firstPlace.subThoroughfare, let thoroughfare = firstPlace.thoroughfare, let postalCode = firstPlace.postalCode, let locality = firstPlace.locality{
//                            self.addressLabel.text = "\(subthoroughfare) \(thoroughfare),\(locality),\(postalCode)"
                        }
                        
                    }
                }
            }
        }
        
        manager.stopUpdatingLocation()
        manager.delegate = nil
    }
}

var didFinish = false
