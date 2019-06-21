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

class AutoCompleteTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class ZJAddAptMapView: UIView {

    var locationManager: CLLocationManager!
    let newPin = MKPointAnnotation()
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var resultTableHeightConstraint: NSLayoutConstraint?

    fileprivate let mapViewHeight: CGFloat = 200
    fileprivate let searchBarHeight: CGFloat = 40

    lazy var searchBar: AutoCompleteTextField = { [weak self] in
       let searchb = AutoCompleteTextField()
        searchb.delegate = self
        searchb.clearButtonMode = .always
        searchb.layer.borderWidth = 0.5
        searchb.layer.borderColor = UIColor.black.cgColor
        searchb.addTarget(self, action: #selector(textFieldEditing), for: .editingChanged)
        return searchb
    }()

    lazy var addressLabel:UILabel = {
       let label = UILabel()
        label.text = "Address:"
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .orange
        label.textColor = .white
        return label
    }()

    fileprivate lazy var resultTableView: UITableView = { [weak self] in
        let tableV = UITableView()
        tableV.dataSource = self
        tableV.delegate = self
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return tableV
    }()

    fileprivate lazy var mapsView: MKMapView = {
        let view = MKMapView()
        view.showsUserLocation = true
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        ZJPrint("mapview creaeted")
        setupLocation()
        setupUI()

        searchCompleter.delegate = self
    }

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

    fileprivate func setupUI() {
        self.addSubview(searchBar)
        searchBar.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: searchBarHeight)

        searchBar.addSubview(addressLabel)
        addressLabel.anchor(top: searchBar.topAnchor, left: searchBar.leftAnchor, bottom: searchBar.bottomAnchor, right: nil, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 0, width: 50, height: 0)

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

extension ZJAddAptMapView: UITextFieldDelegate {

    @objc fileprivate func textFieldEditing(textF: UITextField) {

        guard let text = textF.text else {
            return
        }
        if text == ""{
            self.resultTableHeightConstraint?.constant = 0
            if let topVC = UIApplication.topViewController() as? ZJAddAptViewController {
                topVC.tableView.tableHeaderView?.frame.size.height = originalMapViewH
                topVC.tableView.reloadData()
            }
            return
        }
        searchCompleter.queryFragment = text
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }

}

extension ZJAddAptMapView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let max = 4
        let cellH = 56
        var cellNum = max
        if searchResults.count < max {
            cellNum = searchResults.count
        }
        self.resultTableHeightConstraint?.constant = CGFloat(cellH * cellNum)
        if let topVC = UIApplication.topViewController() as? ZJAddAptViewController {
            topVC.tableView.tableHeaderView?.frame.size.height = originalMapViewH + CGFloat(cellH * cellNum)
            topVC.tableView.reloadData()
        }
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
        mapsView.removeAnnotation(newPin)
        let completion = searchResults[indexPath.row]
        ZJPrint(completion.subtitle)
        ZJPrint(completion.title)
        searchBar.text = completion.title + ", " + completion.subtitle
        if let text = searchBar.text {
            fulladdress = text
        }
        searchBar.resignFirstResponder()
        if let topVC = UIApplication.topViewController() as? ZJAddAptViewController {
            topVC.tableView.tableHeaderView?.frame.size.height = originalMapViewH
            resultTableHeightConstraint = resultTableView.heightAnchor.constraint(equalToConstant: 0)
            resultTableHeightConstraint?.isActive = true
            topVC.tableView.reloadData()
        }

        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, _) in
            /*
            open var thoroughfare: String? { get } // street name, eg. Infinite Loop
            
            open var subThoroughfare: String? { get } // eg. 1
            
            open var locality: String? { get } // city, eg. Cupertino
            
            open var subLocality: String? { get } // neighborhood, common name, eg. Mission District
            
            open var administrativeArea: String? { get } // state, eg. CA
            
            open var subAdministrativeArea: String? { get } // county, eg. Santa Clara
            
            open var postalCode: String? { get } // zip code, eg. 95014
            
            open var isoCountryCode: String? { get } // eg. US
            
            open var country: String? { get } // eg. United States
 */
            if let thoroughfare = response?.mapItems[0].placemark.thoroughfare {
                address = thoroughfare
            }
            if let locality = response?.mapItems[0].placemark.locality {
                city = locality
            }
            if let administrativeArea = response?.mapItems[0].placemark.administrativeArea {
                state = administrativeArea
            }
            if let postalCode = response?.mapItems[0].placemark.postalCode {
                zipcode = postalCode
            }
            if let coordinate = response?.mapItems[0].placemark.coordinate {
                longitude = String(coordinate.longitude)
                latitude = String(coordinate.latitude)
                let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                self.mapsView.setRegion(region, animated: true)

                self.newPin.coordinate = coordinate
                self.mapsView.addAnnotation(self.newPin)
            }
        }
    }

}

extension ZJAddAptMapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapsView.setRegion(region, animated: true)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation.init(latitude: location.coordinate.latitude, longitude:location.coordinate.longitude)) { (places, error) in
                if error == nil {
                    if let place = places {
//                        if let firstPlace = place.first, let subthoroughfare = firstPlace.subThoroughfare, let thoroughfare = firstPlace.thoroughfare, let postalCode = firstPlace.postalCode, let locality = firstPlace.locality {
//                        }
                    }
                }
            }
        }
        manager.stopUpdatingLocation()
        manager.delegate = nil
    }

}
