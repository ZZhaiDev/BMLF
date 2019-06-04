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

//class CustomPointAnnotation: MKPointAnnotation {
//    var imageName: String!
//}

protocol ZJRentAptMapViewDelegate: class {
    func zjRentAptMapViewDidEndDraw()
}


class ZJRentAptMapView: UIView {
    
    var isDrawing = false
    var locationManager: CLLocationManager!
    var points = [CLLocationCoordinate2D]()
    var delegate: ZJRentAptMapViewDelegate?
    var data = [AddAptProperties](){
        didSet{
            for property in data{
                if let lat = property.latitude, let lon = property.longitude{
                    let annotation = CustomizedAnnotation()
//                    annotation.imageName = "Sites-RBC"
                    annotation.data = property
//                    annotation.title = "chicago il"
//                    annotation.subtitle = "1室一厅 u短租"
                    annotation.coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lon)!)
                    mapsView.addAnnotation(annotation)
                }
                
            }
        }
    }
    
    lazy var mapsView: MKMapView = {
        let view = MKMapView()
        view.layer.cornerRadius = 10
        view.showsUserLocation = true
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
        ZJPrint(points.count)
        ZJPrint(points)
        mapsView.addOverlay(polygon)
        points = [] // Reset points
        

        self.delegate?.zjRentAptMapViewDidEndDraw()
        
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
            polylineRenderer.strokeColor = .orange
            polylineRenderer.lineWidth = 1
            return polylineRenderer
        } else if overlay is MKPolygon {
            
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.fillColor = UIColor.lightGray.withAlphaComponent(0.4)
            return polygonView
        }
        return MKPolylineRenderer(overlay: overlay)
    }
    
    //自定义 annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            let av = CustomizedAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = false
            annotationView.frame.size = CGSize(width: 21, height: 36)
            annotationView.image = UIImage(named: "customize_pin")
        }
        
        return annotationView
    }
//    @objc func callPhoneNumber(){
//      ZJPrint("32121")
//    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation{return}
        // 2
        let starbucksAnnotation = view.annotation as! CustomizedAnnotation
//        let views = c
        let calloutView = CustomCalloutView(frame: CGRect(x: 0, y: 0, width: zjScreenWidth*0.6, height: zjScreenHeight*0.5))
        calloutView.data = starbucksAnnotation.data
        
//        let button = UIButton(frame: calloutView.phoneB.frame)
//        button.addTarget(self, action: #selector(callPhoneNumber), for: .touchUpInside)
//        calloutView.addSubview(button)
        
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        guard let tempCoordinate = view.annotation?.coordinate else{
            return
        }
        var centerCoordinate = tempCoordinate
        centerCoordinate.latitude += (mapView.region.span.latitudeDelta * 0.2)
        mapView.setCenter(centerCoordinate, animated: true)
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        ZJPrint(view)
//        MKAnnotationView
        ZJPrint(view.annotation)
        ZJPrint(view.calloutOffset)
        ZJPrint(view.leftCalloutAccessoryView)
        if view.isKind(of: CustomizedAnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
}


extension ZJRentAptMapView: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*
        if let location = locations.last{
            /*
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapsView.setRegion(region, animated: true)
             */
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation.init(latitude: location.coordinate.latitude, longitude:location.coordinate.longitude)) { (places, error) in
                if error == nil{
                    if let place = places{
                        if let firstPlace = place.first, let subthoroughfare = firstPlace.subThoroughfare, let thoroughfare = firstPlace.thoroughfare, let postalCode = firstPlace.postalCode, let locality = firstPlace.locality{
                        }
                    }
                }
            }
        }
        
        manager.stopUpdatingLocation()
        manager.delegate = nil
 */
    }
}
