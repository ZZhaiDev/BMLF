//
//  ZJRentAptViewController.swift
//  BMLF
//
//  Created by zijia on 5/16/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import MapKit
import AFNetworking
import NVActivityIndicatorView
import RealmSwift



fileprivate let searchBarHeight: CGFloat = 30

class ZJRentAptViewController: ZJBaseViewController, NVActivityIndicatorViewable {
    // swiftlint:disable identifier_name
    fileprivate var changeRightBarButtonItem_list = UIBarButtonItem()
    var totalDatas = [AddAptProperties]()
    var realmResult: Results<ZJAddAptRealmModel>?
    var aptViewModel = ZJAptViewModel()
    lazy var cityBoundaryViewModel = CityBoundaryViewModel()
    fileprivate var stackView = UIStackView()
    
    lazy var titleView: UIView = {
       let view = UIView(frame: CGRect(x: 0, y: 0, width: zjScreenWidth/2, height: searchBarHeight))
        return view
    }()
    lazy var searchBar: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height))
        button.backgroundColor = .white
        button.layer.cornerRadius = searchBarHeight/2
        button.layer.masksToBounds = true
        button.setTitle("Choose City", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var drawView: SquareView = {
        let view = SquareView()
        view.data = ["draw", "draw"]
        let gesture = UITapGestureRecognizer(target: self, action: #selector(drawCustomCircle))
        view.addGestureRecognizer(gesture)
        return view
    }()

    fileprivate lazy var locationView: SquareView = {
        let view = SquareView()
        view.data = ["currentLocation", "location"]
        let gesture = UITapGestureRecognizer(target: self, action: #selector(moveCurrentLocation))
        view.addGestureRecognizer(gesture)
        return view
    }()

    lazy var cityView: SquareView = {
        let view = SquareView()
        view.data = ["draw", "city"]
        let gesture = UITapGestureRecognizer(target: self, action: #selector(drawCityBoundray))
        view.addGestureRecognizer(gesture)
        return view
    }()

    lazy var mapView: ZJRentAptMapView = {
        let mv = ZJRentAptMapView()
        mv.layer.cornerRadius = 10
        mv.layer.masksToBounds = true
        mv.delegate = self
        return mv
    }()

    @objc fileprivate func searchButtonClicked() {
        let vc = ZJRentAptFilterViewController()
        self.present(vc, animated: true) {

        }
    }

    @objc fileprivate func didDragMap(gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.ended {
            UIView.animate(withDuration: 0) {
                self.navigationController?.navigationBar.alpha = 1
                self.tabBarController?.tabBar.alpha = 1
                self.mapView.mapsView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            self.view.frame = CGRect(x: 0, y: zjNavigationBarHeight+zjStatusHeight, width: zjScreenWidth, height: zjScreenHeight-zjNavigationBarHeight-zjStatusHeight)
        } else if gesture.state == UIGestureRecognizer.State.began {
            UIView.animate(withDuration: 0.5) {
                self.navigationController?.navigationBar.alpha = 1
                self.tabBarController?.tabBar.alpha = 0
            }
            self.view.frame = CGRect(x: 0, y: zjNavigationBarHeight+zjStatusHeight, width: zjScreenWidth, height: zjScreenHeight-zjNavigationBarHeight-zjStatusHeight)
        }
    }

    lazy var listView: ZJRentAptListView = {
        let lv = ZJRentAptListView()
        return lv
    }()
    
    lazy var indicatorView: IndicaterView = {
        let view = IndicaterView(frame: .zero)
        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        aptViewModel.loadApt { (_) in
            ZJPrint(self.aptViewModel.aptModel.count!)
//            self.feedDataToListAndMapView()
            let count: Int = ZJAptViewModel.pageSize
            let pageCount = (self.aptViewModel.aptModel.count!+count/2)/count
            let dGroup = DispatchGroup()
            for index in 2...pageCount {
                dGroup.enter()
                self.aptViewModel.loadApt(page: index, pageSize: count, finished: { (_) in
//                    self.feedDataToListAndMapView()
                    if index == pageCount {
                        self.realmResult = realmInstance.objects(ZJAddAptRealmModel.self).sorted(byKeyPath: "id")
                        ZJPrint(self.realmResult?.count)
                        self.feedDataToListAndMapView()
                    }
                    dGroup.leave()
                })
            }
        }
        setupUI()
    }
    
    func feedDataToListAndMapView() {
//        self.listView.data = self.aptViewModel.aptProperties
        self.listView.realmData = self.realmResult
        self.mapView.realmData = self.realmResult
//        self.mapView.data = self.aptViewModel.aptProperties
//        self.totalDatas += self.aptViewModel.aptProperties
    }

    deinit {
        ZJPrint("deinit")
    }

    @objc fileprivate func drawCityBoundray() {
        cityBoundaryViewModel.loadCityBoundary(city: "chicago") {
            guard let locations = self.cityBoundaryViewModel.viewModel.coordinates else {return}
            let polygon = MKPolyline(coordinates: locations, count: locations.count)
            self.mapView.mapsView.addOverlay(polygon)
        }
    }

    @objc fileprivate func drawCustomCircle() {
        if drawView.labelV.text == "Cancel"{
            mapView.isDrawing = false
            mapView.mapsView.isUserInteractionEnabled = true
            drawView.data = ["draw", "draw"]
            mapView.mapsView.removeOverlays(mapView.mapsView.overlays)
            indicatorView.isHidden = true
            return
        }
        if mapView.isDrawing == false {
            mapView.isDrawing = true
            indicatorView.isHidden = false
            mapView.mapsView.isUserInteractionEnabled = false
            drawView.data = ["draw", "drawing"]
        }
    }

    @objc fileprivate func moveCurrentLocation() {
        guard let location = mapView.locationManager.location?.coordinate else {return}
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.mapsView.setRegion(region, animated: true)
    }
}

extension ZJRentAptViewController: ZJRentAptMapViewDelegate {
    func zjRentAptMapViewDidEndDraw() {
        mapView.isDrawing = false
        mapView.mapsView.isUserInteractionEnabled = true
        drawView.data = ["draw", "Cancel"]
    }
}

extension ZJRentAptViewController {
    fileprivate func setupUI() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .orange

        self.view.backgroundColor = .orange
        self.view.addSubview(mapView)
        mapView.fillSuperview()
        self.view.addSubview(indicatorView)
        indicatorView.anchor(top: self.mapView.topAnchor, left: nil, bottom: nil, right: self.mapView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: IndicaterView.selfWidth, height: IndicaterView.selfHeight)

        self.view.addSubview(listView)
        listView.fillSuperview()
        let subViews = [drawView, locationView]
        stackView = UIStackView(arrangedSubviews: subViews)
        stackView.setCustomSpacing(SquareView.Space, after: drawView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: zjTabBarHeight+10, paddingRight: 0, width: SquareView.viewW, height: SquareView.Space*CGFloat(subViews.count-1)+SquareView.viewW*CGFloat(subViews.count))
        mapView.alpha = 1
        listView.alpha = 0
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "Logo_english")
        changeRightBarButtonItem_list = UIBarButtonItem(image: UIImage(named: "navigationBar_list"), style: .plain, target: self, action: #selector(rightBarButtonClicked))
        titleView.addSubview(searchBar)
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItems = [changeRightBarButtonItem_list]
    }

    @objc fileprivate func rightBarButtonClicked() {
        showView()
    }

    @objc fileprivate func filterBarButtonClicked() {
    }

    fileprivate func showView() {
        if mapView.alpha == 0 {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.mapView.alpha = 1.0
                self.changeRightBarButtonItem_list.image = UIImage(named: "navigationBar_list")
                self.stackView.alpha = 1.0
                self.listView.alpha = 0
            }) { (_) in
            }

        } else {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.mapView.alpha = 0
                self.stackView.alpha = 0
                self.listView.alpha = 1
                self.changeRightBarButtonItem_list.image = UIImage(named: "navigationBar_map")
            }) { (_) in
            }
        }
    }
}

extension ZJRentAptViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
