//
//  ZJRentAptViewController.swift
//  BMLF
//
//  Created by zijia on 5/16/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class ZJRentAptViewController: ZJBaseViewController {
    
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
//        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.addSubview(mapView)
        mapView.fillSuperview()
        
        self.view.addSubview(listView)
        listView.fillSuperview()
//        listView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: zjTabBarHeight)
        
//        mapView.isHidden = false
//        listView.isHidden = true
        mapView.alpha = 1
        listView.alpha = 0
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "change", style: .plain, target: self, action: #selector(rightBarButtonClicked))
    }
    
    @objc fileprivate func rightBarButtonClicked(){
        showView()
    }
    
    
    
    
    
    fileprivate func showView(){
        if mapView.alpha == 0{
//            UIView.animate(withDuration: 1, animations: {
//                self.mapView.isHidden = false
//                self.listView.isHidden = true
//            }) { (_) in
//
//            }
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
//                self.mapView.isHidden = false
//                self.listView.isHidden = true
                self.mapView.alpha = 1.0
                self.listView.alpha = 0
//                self.navigationController?.navigationBar.prefersLargeTitles = false
            }) { (_) in
                
            }
            
        }else{
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
//                self.mapView.isHidden = true
//                self.listView.isHidden = false
                self.mapView.alpha = 0
                self.listView.alpha = 1
//                self.navigationController?.navigationBar.prefersLargeTitles = true
            }) { (_) in
                
            }
            
        }
    }
}


