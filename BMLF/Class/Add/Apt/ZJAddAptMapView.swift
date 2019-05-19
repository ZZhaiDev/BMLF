//
//  ZJAddAptMapView.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/17/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import MapKit

private let cellId = "cellId"

class ZJAddAptMapView: UIView {

    var locationManager: CLLocationManager!
    let newPin = MKPointAnnotation()
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var resultTableHeightConstraint: NSLayoutConstraint?
    
    fileprivate let mapViewHeight: CGFloat = 200
    fileprivate let searchBarHeight: CGFloat = 40
    
    lazy var searchBar: UITextField = { [weak self] in
       let sb = UITextField()
        sb.delegate = self
        sb.layer.borderWidth = 0.5
        sb.layer.borderColor = UIColor.black.cgColor
        sb.addTarget(self, action: #selector(textFieldEditing), for: .editingChanged)
        return sb
    }()
    
    fileprivate lazy var resultTableView: UITableView = { [weak self] in
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return tv
    }()
    
    fileprivate lazy var mapsView: MKMapView = {
        let view = MKMapView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLocation()
        setupUI()
        
        searchCompleter.delegate = self
    }
    
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
    
    fileprivate func setupUI(){
        self.addSubview(searchBar)
        searchBar.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: searchBarHeight)
        
        self.addSubview(resultTableView)
        resultTableView.anchor(top: self.searchBar.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        resultTableHeightConstraint = resultTableView.heightAnchor.constraint(equalToConstant: 0)
        resultTableHeightConstraint?.isActive = true
        
        self.addSubview(mapsView)
        mapsView.anchor(top: self.resultTableView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: mapViewHeight)
    }
    
}

extension ZJAddAptMapView: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        resultTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension ZJAddAptMapView: UITextFieldDelegate{
    
    @objc fileprivate func textFieldEditing(textF: UITextField){
    
        guard let text = textF.text else{
            return
        }
        ZJPrint(text)
        if text == ""{
            searchBar.resignFirstResponder()

            self.resultTableHeightConstraint?.constant = 0
//            self.heightAnchor.constraint(equalToConstant: originalMapViewH)
            return
        }
        searchCompleter.queryFragment = text
    }

}


extension ZJAddAptMapView: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let max = 4
        let cellH = 56
        var cellNum = max
        if searchResults.count < max{
            cellNum = searchResults.count
        }
        
        
        self.resultTableHeightConstraint?.constant = CGFloat(cellH * cellNum)
//        self.heightAnchor.constraint(equalToConstant: originalMapViewH+CGFloat(cellH * cellNum))
        return cellNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            print(String(describing: coordinate))
        }
    }
    
    
}

extension ZJAddAptMapView: CLLocationManagerDelegate{
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
