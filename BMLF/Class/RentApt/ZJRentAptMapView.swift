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
    
    var locations = [
        [
            -87.846564,
            41.969499
        ],
        [
            -87.846557,
            41.969869
        ],
        [
            -87.846555,
            41.970052
        ],
        [
            -87.846551,
            41.970298
        ],
        [
            -87.846543,
            41.97089
        ],
        [
            -87.846542,
            41.971039
        ],
        [
            -87.84654,
            41.97189
        ],
        [
            -87.8415729,
            41.9719756
        ],
        [
            -87.841591,
            41.970143
        ],
        [
            -87.8410043,
            41.9701536
        ],
        [
            -87.8393465,
            41.9701808
        ],
        [
            -87.836658,
            41.970232
        ],
        [
            -87.8366424,
            41.9713592
        ],
        [
            -87.8379566,
            41.9713567
        ],
        [
            -87.8379368,
            41.9738384
        ],
        [
            -87.84155,
            41.973788
        ],
        [
            -87.8415523,
            41.9746906
        ],
        [
            -87.8366398,
            41.9747766
        ],
        [
            -87.8366377,
            41.9753068
        ],
        [
            -87.8337619,
            41.9753518
        ],
        [
            -87.8337589,
            41.9752439
        ],
        [
            -87.8335921,
            41.9752467
        ],
        [
            -87.8335862,
            41.9749199
        ],
        [
            -87.8334569,
            41.9749175
        ],
        [
            -87.8334108,
            41.9739225
        ],
        [
            -87.8317273,
            41.9739463
        ],
        [
            -87.8317226,
            41.9730771
        ],
        [
            -87.8283321,
            41.9731182
        ],
        [
            -87.826739,
            41.9731501
        ],
        [
            -87.826735,
            41.974034
        ],
        [
            -87.825563,
            41.974062
        ],
        [
            -87.8252597,
            41.9740702
        ],
        [
            -87.8239366,
            41.9740829
        ],
        [
            -87.823442,
            41.974119
        ],
        [
            -87.822248,
            41.974149
        ],
        [
            -87.819401,
            41.974223
        ],
        [
            -87.819435,
            41.973221
        ],
        [
            -87.8190813,
            41.9732206
        ],
        [
            -87.819077,
            41.9731278
        ],
        [
            -87.8189644,
            41.9731298
        ],
        [
            -87.8189992,
            41.9721168
        ],
        [
            -87.8189773,
            41.970618
        ],
        [
            -87.8184183,
            41.9706302
        ],
        [
            -87.8175195,
            41.9706487
        ],
        [
            -87.816953,
            41.97066
        ],
        [
            -87.816952,
            41.970728
        ],
        [
            -87.816949,
            41.970934
        ],
        [
            -87.816949,
            41.971003
        ],
        [
            -87.816948,
            41.971116
        ],
        [
            -87.816945,
            41.971454
        ],
        [
            -87.816945,
            41.971568
        ],
        [
            -87.816943,
            41.971749
        ],
        [
            -87.816937,
            41.972293
        ],
        [
            -87.816929,
            41.973201
        ],
        [
            -87.816917,
            41.974289
        ],
        [
            -87.8153017,
            41.974334
        ],
        [
            -87.8116993,
            41.9744309
        ],
        [
            -87.808046,
            41.974518
        ],
        [
            -87.807067,
            41.974538
        ],
        [
            -87.807069,
            41.973857
        ],
        [
            -87.807066,
            41.973688
        ],
        [
            -87.807063,
            41.973495
        ],
        [
            -87.80706,
            41.973196
        ],
        [
            -87.807064,
            41.973009
        ],
        [
            -87.807069,
            41.972918
        ],
        [
            -87.807072,
            41.972885
        ],
        [
            -87.8070779,
            41.9727304
        ],
        [
            -87.807077,
            41.972557
        ],
        [
            -87.807085,
            41.972053
        ],
        [
            -87.80709,
            41.97169
        ],
        [
            -87.807098,
            41.971108
        ],
        [
            -87.807101,
            41.970914
        ],
        [
            -87.807103,
            41.970745
        ],
        [
            -87.807111,
            41.970242
        ],
        [
            -87.807114,
            41.970074
        ],
        [
            -87.807118,
            41.969878
        ],
        [
            -87.807122,
            41.969702
        ],
        [
            -87.80714,
            41.969293
        ],
        [
            -87.807146,
            41.969181
        ],
        [
            -87.807146,
            41.968932
        ],
        [
            -87.807146,
            41.968892
        ],
        [
            -87.807153,
            41.968435
        ],
        [
            -87.807156,
            41.96827
        ],
        [
            -87.805791,
            41.968278
        ],
        [
            -87.80466,
            41.968284
        ],
        [
            -87.8025426,
            41.9682923
        ],
        [
            -87.8025264,
            41.9687461
        ],
        [
            -87.793799,
            41.9688156
        ],
        [
            -87.78801,
            41.968867
        ],
        [
            -87.7880146,
            41.9686509
        ],
        [
            -87.788013,
            41.968411
        ],
        [
            -87.787764,
            41.968412
        ],
        [
            -87.787549,
            41.968414
        ],
        [
            -87.78702,
            41.968422
        ],
        [
            -87.786772,
            41.968427
        ],
        [
            -87.786759,
            41.968384
        ],
        [
            -87.786752,
            41.968326
        ],
        [
            -87.786752,
            41.96824
        ],
        [
            -87.7867374,
            41.9671205
        ],
        [
            -87.7867502,
            41.9660901
        ],
        [
            -87.786757,
            41.965025
        ],
        [
            -87.786762,
            41.964647
        ],
        [
            -87.786763,
            41.964348
        ],
        [
            -87.786769,
            41.96355
        ],
        [
            -87.786779,
            41.963471
        ],
        [
            -87.786792,
            41.963458
        ],
        [
            -87.78681,
            41.963444
        ],
        [
            -87.78696,
            41.963031
        ],
        [
            -87.786812,
            41.960673
        ],
        [
            -87.7868014,
            41.960205
        ],
        [
            -87.7941616,
            41.9600801
        ],
        [
            -87.7942767,
            41.9600575
        ],
        [
            -87.8013402,
            41.9567116
        ],
        [
            -87.8023537,
            41.9562154
        ],
        [
            -87.8032047,
            41.9558063
        ],
        [
            -87.807291,
            41.953866
        ],
        [
            -87.807269,
            41.952765
        ],
        [
            -87.812186,
            41.9526521
        ],
        [
            -87.812225,
            41.952651
        ],
        [
            -87.8133944,
            41.9526241
        ],
        [
            -87.813433,
            41.952624
        ],
        [
            -87.8146096,
            41.9525961
        ],
        [
            -87.814634,
            41.952594
        ],
        [
            -87.814877,
            41.952587
        ],
        [
            -87.815605,
            41.952569
        ],
        [
            -87.815849,
            41.952563
        ],
        [
            -87.815899,
            41.952562
        ],
        [
            -87.816092,
            41.952557
        ],
        [
            -87.816823,
            41.952539
        ],
        [
            -87.8219647,
            41.9523896
        ],
        [
            -87.82321,
            41.95238
        ],
        [
            -87.823589,
            41.95237
        ],
        [
            -87.8236396,
            41.9523736
        ],
        [
            -87.823649,
            41.952369
        ],
        [
            -87.825259,
            41.952328
        ],
        [
            -87.827215,
            41.952279
        ],
        [
            -87.829103,
            41.952231
        ],
        [
            -87.8302865,
            41.9522087
        ],
        [
            -87.8318069,
            41.9521662
        ],
        [
            -87.8318109,
            41.9524986
        ],
        [
            -87.831815,
            41.953782
        ],
        [
            -87.8318093,
            41.9545463
        ],
        [
            -87.831834,
            41.955171
        ],
        [
            -87.831822,
            41.955473
        ],
        [
            -87.831821,
            41.955478
        ],
        [
            -87.831821,
            41.955701
        ],
        [
            -87.831856,
            41.95585
        ],
        [
            -87.831872,
            41.955925
        ],
        [
            -87.831967,
            41.956377
        ],
        [
            -87.831975,
            41.95645
        ],
        [
            -87.831991,
            41.956549
        ],
        [
            -87.832002,
            41.956609
        ],
        [
            -87.832075,
            41.956979
        ],
        [
            -87.83223,
            41.957594
        ],
        [
            -87.832342,
            41.958017
        ],
        [
            -87.832493,
            41.958628
        ],
        [
            -87.832604,
            41.959076
        ],
        [
            -87.832639,
            41.959272
        ],
        [
            -87.8326719,
            41.9594283
        ],
        [
            -87.836699,
            41.95936
        ],
        [
            -87.8367,
            41.959885
        ],
        [
            -87.836695,
            41.9665866
        ],
        [
            -87.8375344,
            41.9665844
        ],
        [
            -87.8380313,
            41.966578
        ],
        [
            -87.842742,
            41.966483
        ],
        [
            -87.8438094,
            41.9664622
        ],
        [
            -87.8444476,
            41.9664523
        ],
        [
            -87.84656,
            41.966407
        ],
        [
            -87.846559,
            41.966769
        ],
        [
            -87.846559,
            41.967858
        ],
        [
            -87.8465611,
            41.9682332
        ],
        [
            -87.846562,
            41.9683152
        ],
        [
            -87.846559,
            41.968405
        ],
        [
            -87.846562,
            41.968954
        ],
        [
            -87.846563,
            41.969138
        ],
        [
            -87.846563,
            41.96932
        ],
        [
            -87.846564,
            41.969499
        ]
    ]
    
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
        
        var coordinates = [CLLocationCoordinate2D]()
        for location in locations{
            coordinates.append(CLLocationCoordinate2D(latitude: location[1], longitude: location[0]))
        }
//        let point1 = CLLocationCoordinate2D(latitude: 41.896963, longitude: -87.817812);
//        let point2 = CLLocationCoordinate2D(latitude: 42.0, longitude: -87.817812);
//        let polygon = MKPolyline(coordinates: coordinates, count: locations.count)
        let polygon = MKPolyline(coordinates: coordinates, count: locations.count)
        mapsView.addOverlay(polygon)
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
