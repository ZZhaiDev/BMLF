//
//  ZJRentAptViewController.swift
//  BMLF
//
//  Created by zijia on 5/16/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class ZJRentAptViewController: ZJBaseViewController {
    
    fileprivate lazy var drawButton: UIButton = {
       let db = UIButton()
        db.backgroundColor = .white
        db.setTitleColor(.blue, for: .normal)
        db.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        db.setTitle("draw", for: .normal)
        db.addTarget(self, action: #selector(drawButtonClicked), for: .touchUpInside)
        return db
    }()
    
    fileprivate lazy var mapView: ZJRentAptMapView = {
        let mv = ZJRentAptMapView()
        return mv
    }()
    
    fileprivate lazy var listView: ZJRentAptListView = {
        let lv = ZJRentAptListView()
        return lv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
}

extension ZJRentAptViewController{
    fileprivate func setupUI(){
        
        self.view.addSubview(mapView)
        mapView.fillSuperview()
        
        self.view.addSubview(listView)
        listView.fillSuperview()
        
        self.view.addSubview(drawButton)
        let width: CGFloat = 50
        drawButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 20, width: width, height: width)
        drawButton.layer.cornerRadius = width/2
        drawButton.layer.masksToBounds = true
        
        mapView.alpha = 1
        listView.alpha = 0
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "change", style: .plain, target: self, action: #selector(rightBarButtonClicked))
    }
    
    @objc fileprivate func rightBarButtonClicked(){
        showView()
    }
    
    
    @objc fileprivate func drawButtonClicked(){
        if mapView.isDrawing == false{
            mapView.isDrawing = true
            mapView.mapsView.isUserInteractionEnabled = false
            drawButton.setTitle("Cancel", for: .normal)
        }else{
            mapView.isDrawing = false
            mapView.mapsView.isUserInteractionEnabled = true
//            mapView.mapsView.removeOverlays(mapView.mapsView.overlays)
            drawButton.setTitle("Draw", for: .normal)
        }
    }
    
    
    
    fileprivate func showView(){
        if mapView.alpha == 0{
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.mapView.alpha = 1.0
                self.listView.alpha = 0
            }) { (_) in
                
            }
            
        }else{
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.mapView.alpha = 0
                self.listView.alpha = 1
            }) { (_) in
                
            }
        }
    }
}


