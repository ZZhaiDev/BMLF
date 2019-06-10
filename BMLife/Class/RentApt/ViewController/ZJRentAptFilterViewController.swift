//
//  ZJRentAptFilterViewController.swift
//  BMLife
//
//  Created by Zijia Zhai on 6/4/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import MapKit
private let cellId = "cellId"

private let hotViewHeight: CGFloat = 100

class ZJRentAptFilterViewController: UIViewController {

    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    lazy var searchBar: PaddingTextField = { [weak self] in
        let sb = PaddingTextField()
        sb.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        sb.placeholder = "Enter Your Address"
        sb.font = UIFont.systemFont(ofSize: 12)
        sb.delegate = self
        sb.clearButtonMode = .always
        sb.layer.cornerRadius = 15
        sb.layer.masksToBounds = true
        sb.addTarget(self, action: #selector(textFieldEditing), for: .editingChanged)
        return sb
    }()

    lazy var cancelButton: UIButton = {
       let button = UIButton(frame: .zero)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        return button
    }()

    @objc fileprivate func cancelButtonClicked() {
        searchBar.resignFirstResponder()
        self.dismiss(animated: true) {

        }
    }

    func dismissWithCity(city: String) {
        searchBar.resignFirstResponder()
        self.dismiss(animated: true) {
            if let topVC = UIApplication.topViewController() as? ZJRentAptViewController {
                let mapView = topVC.mapView.mapsView
                CLGeocoder().geocodeAddressString(city, completionHandler: { (placeMark, err) in
                    if err != nil {
                        ZJPrint(err)
                        return
                    }
                    guard let center = placeMark?.first?.location?.coordinate else {
                        return
                    }
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))

                    mapView.setRegion(region, animated: true)
                })
            }
        }
    }

    fileprivate lazy var resultTableView: UITableView = { [weak self] in
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return tv
    }()

    fileprivate lazy var hotView: ZJRentAptFilterHotView = {
        let hv = ZJRentAptFilterHotView(frame: CGRect(x: 0, y: -hotViewHeight, width: zjScreenWidth, height: hotViewHeight))
        return hv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        searchBar.becomeFirstResponder()
        setupUI()
        // Do any additional setup after loading the view.
    }

    fileprivate func setupUI() {
        self.view.addSubview(searchBar)
        searchBar.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: zjStatusHeight+5, paddingLeft: 5, paddingBottom: 0, paddingRight: 60, width: 0, height: 30)

        self.view.addSubview(cancelButton)
        cancelButton.anchor(top: nil, left: searchBar.rightAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        cancelButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: searchBar.heightAnchor).isActive = true

        self.view.addSubview(resultTableView)
        resultTableView.anchor(top: self.searchBar.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        resultTableView.contentInset = UIEdgeInsets(top: hotViewHeight, left: 0, bottom: 0, right: 0)

        resultTableView.addSubview(hotView)

    }
}

extension ZJRentAptFilterViewController: UITextFieldDelegate {

    @objc fileprivate func textFieldEditing(textF: UITextField) {

        guard let text = textF.text else {
            return
        }
        ZJPrint(text)
        if text == ""{
//            if let topVC = UIApplication.topViewController() as? ZJAddAptViewController{
//                topVC.tableView.tableHeaderView?.frame.size.height = originalMapViewH
//                topVC.tableView.reloadData()
//            }
//            return
        }
        searchCompleter.queryFragment = text
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }

}

extension ZJRentAptFilterViewController: MKLocalSearchCompleterDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        searchResults = completer.results
        self.searchResults = completer.results.filter { result in
            if !result.title.contains(",") {
                return false
            }

            if result.title.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
                return false
            }

            if result.subtitle.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
                return false
            }

            return true
        }
        resultTableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }

}

extension ZJRentAptFilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ZJPrint(searchResults.count)
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let completion = searchResults[indexPath.row]
        if let city = completion.title.components(separatedBy: ",").first {
            dismissWithCity(city: city)
        }

    }
}
