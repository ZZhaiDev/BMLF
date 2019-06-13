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

private let squareViewW: CGFloat = 50
private let stackViewSpace: CGFloat = 10
class SquareView: UIView {

    lazy var imageV: UIImageView = {
       let iv = UIImageView()
        return iv
    }()

    lazy var labelV: UILabel = {
        let iv = UILabel()
        iv.textAlignment = .center
        iv.textColor = UIColor.darkGray
        iv.font = UIFont.systemFont(ofSize: 10)
        return iv
    }()

    var data: [String]? {
        didSet {
            guard let data = data else {return}
            imageV = UIImageView(image: UIImage(named: data[0]))
            labelV.text = data[1]
            setupUI()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.borderWidth = 1

    }

    fileprivate func setupUI() {

//        aptViewModel.loadApt { (responce) in
//        }

        self.addSubview(imageV)
//        let w = self.frame.size.width
        imageV.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: squareViewW/3, height: squareViewW/3)
        imageV.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageV.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5).isActive = true

        self.addSubview(labelV)
        labelV.anchor(top: imageV.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        labelV.centerXAnchor.constraint(equalTo: imageV.centerXAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let searchBarHeight: CGFloat = 30

class ZJRentAptViewController: ZJBaseViewController {
    // swiftlint:disable identifier_name
    var changeRightBarButtonItem_list = UIBarButtonItem()

//    fileprivate lazy var drawButton: UIButton = {
//       let db = UIButton()
//        db.backgroundColor = .white
//        db.setTitleColor(.blue, for: .normal)
//        db.titleLabel?.font = UIFont.systemFont(ofSize: 10)
//        db.setTitle("draw", for: .normal)
//        db.addTarget(self, action: #selector(drawButtonClicked), for: .touchUpInside)
//        return db
//    }()
    lazy var titleView: UIView = {
       let view = UIView(frame: CGRect(x: 0, y: 0, width: zjScreenWidth/2, height: searchBarHeight))
        return view
    }()
    lazy var searchBar: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height))
        button.backgroundColor = .white
//        b.layer.borderColor = UIColor.lightGray.cgColor
//        b.layer.borderWidth = 0.5
        button.layer.cornerRadius = searchBarHeight/2
        button.layer.masksToBounds = true
        button.setTitle("Enter Address", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        return button
    }()

    var aptViewModel = ZJAptViewModel()
    lazy var cityBoundaryViewModel = CityBoundaryViewModel()
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

    var stackView = UIStackView()

    lazy var mapView: ZJRentAptMapView = {
        let mv = ZJRentAptMapView()
        mv.layer.cornerRadius = 10
        mv.layer.masksToBounds = true
        mv.delegate = self
//        let gesture = UIPanGestureRecognizer(target: self, action: #selector(didDragMap))
//        gesture.delegate = self
//        mv.addGestureRecognizer(gesture)
        return mv
    }()

    @objc fileprivate func searchButtonClicked() {
        let vc = ZJRentAptFilterViewController()
        self.present(vc, animated: true) {

        }
    }

    @objc fileprivate func didDragMap(gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.ended {
//            self.navigationController?.navigationBar.isHidden = false
//            self.tabBarController?.tabBar.isHidden = false
//            self.navigationController?.navigationBar.alpha = 1
//            self.tabBarController?.tabBar.alpha = 1
            UIView.animate(withDuration: 0) {
                self.navigationController?.navigationBar.alpha = 1
                self.tabBarController?.tabBar.alpha = 1
//                self.mapView.mapsView.bounds = self.mapView.mapsView.frame.insetBy(dx: 0, dy: -20.0)
                self.mapView.mapsView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//                self.mapView.mapsView.layoutMargins = UIEdgeInsets(top: -(zjNavigationBarHeight+zjStatusHeight), left: 0, bottom: 0, right: 0)
//                self.mapView.mapsView.frame.origin.y = -(zjNavigationBarHeight+zjStatusHeight)
//                self.mapView.mapsView.frame.origin.x = 30

            }
            self.view.frame = CGRect(x: 0, y: zjNavigationBarHeight+zjStatusHeight, width: zjScreenWidth, height: zjScreenHeight-zjNavigationBarHeight-zjStatusHeight)
//            self.view.frame.origin.y = zjNavigationBarHeight
//            mapView.layer.cornerRadius = 10
//            mapView.layer.masksToBounds = true
        } else if gesture.state == UIGestureRecognizer.State.began {
//            self.navigationController?.navigationBar.isHidden = true
//            self.tabBarController?.tabBar.isHidden = true
            UIView.animate(withDuration: 0.5) {
                self.navigationController?.navigationBar.alpha = 1
                self.tabBarController?.tabBar.alpha = 0
            }
            self.view.frame = CGRect(x: 0, y: zjNavigationBarHeight+zjStatusHeight, width: zjScreenWidth, height: zjScreenHeight-zjNavigationBarHeight-zjStatusHeight)
//            self.view.frame.origin.y = 0
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

    var totalDatas = [AddAptProperties]()
    override func viewDidLoad() {
        super.viewDidLoad()
        aptViewModel.loadApt { (_) in
            ZJPrint(self.aptViewModel.aptModel.count!)
            self.feedDataToListAndMapView()
            let count: Int = ZJAptViewModel.pageSize
            let pageCount = (self.aptViewModel.aptModel.count!+count/2)/count
            let dGroup = DispatchGroup()
            for index in 2...pageCount{
                dGroup.enter()
                self.aptViewModel.loadApt(page: index, pageSize: count, finished: { (_) in
                    self.feedDataToListAndMapView()
                    dGroup.leave()
                })
            }
        }
        setupUI()
    }
    
    func feedDataToListAndMapView(){
        self.listView.data = self.aptViewModel.aptProperties
        self.mapView.data = self.aptViewModel.aptProperties
        self.totalDatas += self.aptViewModel.aptProperties
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
        stackView.setCustomSpacing(stackViewSpace, after: drawView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: zjTabBarHeight+10, paddingRight: 0, width: squareViewW, height: stackViewSpace*CGFloat(subViews.count-1)+squareViewW*CGFloat(subViews.count))
        mapView.alpha = 1
        listView.alpha = 0
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "Logo_english")
        changeRightBarButtonItem_list = UIBarButtonItem(image: UIImage(named: "navigationBar_list"), style: .plain, target: self, action: #selector(rightBarButtonClicked))
        titleView.addSubview(searchBar)
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItems = [ changeRightBarButtonItem_list]
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
