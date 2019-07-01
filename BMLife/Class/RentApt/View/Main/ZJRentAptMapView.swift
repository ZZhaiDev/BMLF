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
import NVActivityIndicatorView
import RealmSwift

var userCurrentCoordinate: CLLocationCoordinate2D?

protocol ZJRentAptMapViewDelegate: class {
    func zjRentAptMapViewDidEndDraw()
}

class ZJRentAptMapView: UIView {
    var isDrawing = false
    var locationManager: CLLocationManager!
    var points = [CLLocationCoordinate2D]()
    weak var delegate: ZJRentAptMapViewDelegate?
    var zoomLevel: CGFloat = 20
    var zipcodeAndCrimeViewModel = ZipcodeAndCrimeViewModel()
    var data = [AddAptProperties]() {
        didSet {
            ZJPrint(data.count)
            for property in data {
                if let lat = property.latitude, let lon = property.longitude {
                    let annotation = CustomizedAnnotation()
                    annotation.data = property
                    annotation.coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lon)!)
                    DispatchQueue.main.async {
                        self.mapsView.addAnnotation(annotation)
                        ZJPrint(self.mapsView.annotations.count)
                    }
                }
            }
        }
    }
    
    var realmData: Results<ZJAddAptRealmModel>? {
        didSet {
            guard let realmData = realmData else { return }
            for realm in realmData {
                let annotation = CustomizedAnnotation()
                annotation.realmData = realm
                annotation.coordinate = CLLocationCoordinate2D(latitude: Double(realm.latitude)!, longitude: Double(realm.longitude)!)
                DispatchQueue.main.async {
                    self.mapsView.addAnnotation(annotation)
//                    ZJPrint(self.mapsView.annotations.count)
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

    fileprivate func setupLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
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

    fileprivate func setupUI() {
        self.addSubview(mapsView)
        mapsView.fillSuperview()
    }
}

//:MARK -- 画圈
extension ZJRentAptMapView {
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
        var coordinatesArr = ""
        for point in points {
            coordinatesArr += ",\(point.longitude),\(point.latitude)"
        }
        coordinatesArr.removeFirst()
        coordinatesArr += ",\(points.first!.longitude),\(points.first!.latitude)"
        /*
        crimeViewModel.loadCrime(dictValue: temp) {
            self.crimeViewModel.crimeProperties.forEach({ (property) in
                if let lon = property.longitude, let lat = property.latitude, let crime = property.parent_incident_type, let time = property.incident_datetime{
                    let annotation = CrimeAnnotation()
                    annotation.title = crime
                    annotation.subtitle = time
                    annotation.coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lon)!)
                    self.mapsView.addAnnotation(annotation)
                }
                
            })
        }
 */
        if let topVC = UIApplication.topViewController() as? ZJRentAptViewController {
            topVC.startAnimating(CGSize(width: 30, height: 30), message: "drawing crime map...", fadeInAnimation: nil)
        }
        zipcodeAndCrimeViewModel.loadZipcodeAndCrime(dictValue: coordinatesArr) {
            for data in self.zipcodeAndCrimeViewModel.datas {
                DispatchQueue.global().async {
                    let coordinates = data.coordinates
                    var coorResult = [CLLocationCoordinate2D]()
                    for coordinate in coordinates {
                        let tempCoor = CLLocationCoordinate2D(latitude: coordinate[1], longitude: coordinate[0])
                        coorResult.append(tempCoor)
                    }
                    DispatchQueue.main.async {
                        ZJPrint(data.zipCode)
                        let dangerousLevelCorlorDict = UIColor.dangerouseLevelColor(crimeCount: data.crimeCount)
                        let polygonArea = MKPolygon(coordinates: &coorResult, count: coorResult.count)
                        polygonArea.title = String(dangerousLevelCorlorDict["level"] as! Int)
                        self.mapsView.addOverlay(polygonArea)
                        let polygonline = MKPolyline(coordinates: coorResult, count: coorResult.count)
                        self.mapsView.addOverlay(polygonline)
                    }
                }
            }
            if let topVC = UIApplication.topViewController() as? ZJRentAptViewController {
                topVC.stopAnimating()
            }
        }
        mapsView.addOverlay(polygon)
        points = []
        self.delegate?.zjRentAptMapViewDidEndDraw()
    }
}

extension ZJRentAptMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            if isDrawing == false {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = UIColor.gray
                renderer.lineWidth = 0.5
                return renderer
            }
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .orange
            polylineRenderer.lineWidth = 1
            return polylineRenderer
        } else if overlay is MKPolygon {
            if isDrawing == false {
                if let text = overlay.title, let tempText = text, let level = Int(tempText) {
                    if level == -1 {
                        let polygonView = MKPolygonRenderer(overlay: overlay)
                        polygonView.fillColor = UIColor.white.withAlphaComponent(0.5)
                        return polygonView
                    } else {
                        let polygonView = MKPolygonRenderer(overlay: overlay)
                        polygonView.fillColor = UIColor.dangerouseLevelColorArr[level]
                        return polygonView
                    }
                }
            }
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.fillColor = UIColor.lightGray.withAlphaComponent(0.4)
            return polygonView
        }
        return MKPolylineRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }

        /*
         //画crime 点
        guard !(annotation is CrimeAnnotation) else {
            let Identifier = "CrimeIdentifier"
            var : MKAnnotationView?
            if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Identifier) {
                crimeAnnotion = dequeuedAnnotationView
                crimeAnnotion?.annotation = annotation
            }else {
                let av = CrimeAnnotationView(annotation: annotation, reuseIdentifier: Identifier)
                av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                crimeAnnotion = av
            }
            
            if let annotationView = crimeAnnotion {
                annotationView.canShowCallout = false
                annotationView.frame.size = CGSize(width: 21, height: 21)
                annotationView.image = UIImage(named: "Crime_annotation1")
            }
            return crimeAnnotion
        }
         */
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        } else {
            let customeAV = CustomizedAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            customeAV.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = customeAV
        }

        if let annotationView = annotationView {
            annotationView.canShowCallout = false
            annotationView.frame.size = CGSize(width: 21, height: 36)
            annotationView.image = UIImage(named: "customize_pin")
        }
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {return}
        // swiftlint:disable force_cast
        let starbucksAnnotation = view.annotation as! CustomizedAnnotation
        let calloutView = CustomCalloutView(frame: CGRect(x: 0, y: 0, width: zjScreenWidth*0.6, height: zjScreenHeight*0.5))
//        calloutView.data = starbucksAnnotation.data
        calloutView.realmData = starbucksAnnotation.realmData
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        guard let tempCoordinate = view.annotation?.coordinate else {return}
        var centerCoordinate = tempCoordinate
        centerCoordinate.latitude += (mapView.region.span.latitudeDelta * 0.2)
        mapView.setCenter(centerCoordinate, animated: true)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        ZJPrint(view.annotation)
        ZJPrint(view.calloutOffset)
        ZJPrint(view.leftCalloutAccessoryView)
        if view.isKind(of: CustomizedAnnotationView.self) {
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
        }
    }
}

extension ZJRentAptMapView: CLLocationManagerDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let centralLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude:  mapView.centerCoordinate.longitude)
        guard let topVC = UIApplication.topViewController() as? ZJRentAptViewController else {return}
        if zoomLevel > getRadius(centralLocation: centralLocation, mapView: mapView) {
            topVC.drawView.isUserInteractionEnabled = true
            topVC.drawView.alpha = 1
        } else {
            topVC.drawView.isUserInteractionEnabled = false
            topVC.drawView.alpha = 0.5
        }
    }
    ///calculate zoom level
    func getRadius(centralLocation: CLLocation, mapView: MKMapView) -> CGFloat {
        let topCentralLat:Double = centralLocation.coordinate.latitude -  mapView.region.span.latitudeDelta/2
        let topCentralLocation = CLLocation(latitude: topCentralLat, longitude: centralLocation.coordinate.longitude)
        let radius = centralLocation.distance(from: topCentralLocation)
        return CGFloat(radius / 1000.0) // to convert radius to meters
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            userCurrentCoordinate = center
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            self.mapsView.setRegion(region, animated: true)

            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation.init(latitude: location.coordinate.latitude, longitude:location.coordinate.longitude)) { (places, error) in
                if error == nil {
                }
            }
        }
        manager.stopUpdatingLocation()
        manager.delegate = nil
    }
}
