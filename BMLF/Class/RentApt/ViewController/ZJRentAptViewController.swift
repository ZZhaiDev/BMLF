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
class SquareView: UIView{
    lazy var imageV: UIImageView = {
       let iv = UIImageView()
        return iv
    }()
    
    lazy var labelV: UILabel = {
        let iv = UILabel()
        iv.textAlignment = .center
        iv.textColor = UIColor.darkGray
        iv.font = UIFont.systemFont(ofSize: 12)
        return iv
    }()
    
    var data: [String]?{
        didSet{
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
    
    fileprivate func setupUI(){
    
        
        
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

class ZJRentAptViewController: ZJBaseViewController {
    
//    fileprivate lazy var drawButton: UIButton = {
//       let db = UIButton()
//        db.backgroundColor = .white
//        db.setTitleColor(.blue, for: .normal)
//        db.titleLabel?.font = UIFont.systemFont(ofSize: 10)
//        db.setTitle("draw", for: .normal)
//        db.addTarget(self, action: #selector(drawButtonClicked), for: .touchUpInside)
//        return db
//    }()
    lazy var cityBoundaryViewModel = CityBoundaryViewModel()
    fileprivate lazy var drawView: SquareView = {
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
    
    fileprivate lazy var cityView: SquareView = {
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
//        let gesture = UIPanGestureRecognizer(target: self, action: #selector(didDragMap))
//        gesture.delegate = self
//        mv.addGestureRecognizer(gesture)
        return mv
    }()
    
    @objc fileprivate func didDragMap(gesture: UIPanGestureRecognizer){
        if gesture.state == UIGestureRecognizer.State.ended{
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
        }else if gesture.state == UIGestureRecognizer.State.began{
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
    
    fileprivate lazy var listView: ZJRentAptListView = {
        let lv = ZJRentAptListView()
        return lv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let url = "https://3dxcuahqad.execute-api.us-east-1.amazonaws.com/v1/uploadimage"
        let dict = ["filePath": "test.jpg", "contentType": "image/jpeg", "contentEncoding": "base64"]
        ApiService.callPost(url: URL(string: url)!, params: dict) { (arg0) in
            
            let (message, data) = arg0
            do
            {
                ZJPrint(message)
                if let jsonData = data
                {
                    ZJPrint(jsonData)
                    var str = String(decoding: jsonData, as: UTF8.self)
                    ZJPrint(str)
//                    str = "https://www.blissmotors-web-upload.s3.amazonaws.com/crime.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAX7JZ5S7OYYBHPMNO%2F20190523%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20190523T193510Z&X-Amz-Expires=600&X-Amz-SignedHeaders=content-encoding%3Bcontent-type%3Bhost&X-Amz-Signature=4d6bbaecf13e17fcfba1cb0cde6d448f4d8055a6b02211737f13adccf6b8fb3c"
//                    self.upload(image: UIImage(named: "crime")!, urlString: str, mimeType: "image/jpeg", completion: { (bool, error) in
//                        
//                    })
                    ApiService.uploadToS3(image: UIImage(named: "test")!, urlString: str, completion: { (data, err) in
                        
                    })
                }
            }
            catch
            {
                print("Parse Error: \(error)")
            }
        }
    }
    
    
    
    @objc fileprivate func drawCityBoundray(){
        cityBoundaryViewModel.loadCityBoundary(city: "chicago") {
            guard let locations = self.cityBoundaryViewModel.viewModel.coordinates else {return}
            let polygon = MKPolyline(coordinates: locations, count: locations.count)
            self.mapView.mapsView.addOverlay(polygon)
        }
    }
    
    @objc fileprivate func drawCustomCircle(){
        if mapView.isDrawing == false{
            mapView.isDrawing = true
            mapView.mapsView.isUserInteractionEnabled = false
            drawView.data = ["draw", "Cancel"]
        }else{
            mapView.isDrawing = false
            mapView.mapsView.isUserInteractionEnabled = true
            drawView.data = ["draw", "draw"]
        }
    }
    
    @objc fileprivate func moveCurrentLocation(){
        guard let location = mapView.locationManager.location?.coordinate else {return}
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.mapsView.setRegion(region, animated: true)
    }
    
}

extension ZJRentAptViewController{
    fileprivate func setupUI(){
        
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .orange
        
        self.view.backgroundColor = .orange
        self.view.addSubview(mapView)
        mapView.fillSuperview()
        
        self.view.addSubview(listView)
        listView.fillSuperview()
        
        stackView = UIStackView(arrangedSubviews: [drawView, locationView, cityView])
        stackView.setCustomSpacing(stackViewSpace, after: drawView)
        stackView.setCustomSpacing(stackViewSpace, after: locationView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: zjTabBarHeight+10, paddingRight: 0, width: squareViewW, height: stackViewSpace*2+squareViewW*3)
        
//        self.view.addSubview(drawButton)
//        let width: CGFloat = 50
//        drawButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 20, width: width, height: width)
//        drawButton.layer.cornerRadius = width/2
//        drawButton.layer.masksToBounds = true
        
        mapView.alpha = 1
        listView.alpha = 0
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo_white")
//        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "change", style: .plain, target: self, action: #selector(rightBarButtonClicked))
    }
    
    @objc fileprivate func rightBarButtonClicked(){
        showView()
    }
    
    
//    @objc fileprivate func drawButtonClicked(){
//    }
    
    
    
    fileprivate func showView(){
        if mapView.alpha == 0{
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.mapView.alpha = 1.0
                self.stackView.alpha = 1.0
                self.listView.alpha = 0
            }) { (_) in
                
            }
            
        }else{
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.mapView.alpha = 0
                self.stackView.alpha = 0
                self.listView.alpha = 1
            }) { (_) in
                
            }
        }
    }
}

extension ZJRentAptViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


