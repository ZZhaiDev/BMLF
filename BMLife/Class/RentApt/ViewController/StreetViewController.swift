//
//  StreetViewController.swift
//  Carloudy
//
//  Created by Zijia Zhai on 7/26/18.
//  Copyright © 2018 Cognitive AI Technologies. All rights reserved.
//

import UIKit
import GoogleMaps

class StreetViewController: UIViewController, GMSPanoramaViewDelegate {

    var destinationLatitude : CLLocationDegrees?
    var destinationLongitude : CLLocationDegrees?
    var statusViewBackGroundCorlor = UIColor()

    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }
    @IBOutlet weak var panoramaView: GMSPanoramaView!
    override func viewDidLoad() {
        super.viewDidLoad()
        panoramaView.delegate  = self
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if destinationLongitude != nil && destinationLatitude != nil {
            panoramaView.moveNearCoordinate(CLLocationCoordinate2D(latitude: destinationLatitude!, longitude: destinationLongitude!))
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = .clear
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = statusViewBackGroundCorlor
    }

    func panoramaView(_ view: GMSPanoramaView, error: Error, onMoveNearCoordinate coordinate: CLLocationCoordinate2D) {
        print(error)
        let lable = UILabel(frame: CGRect(x: 20, y: 100, width: zjScreenWidth-40, height: 50))
        lable.text = "No Street View Found"
        lable.textColor = UIColor.white
        lable.textAlignment = .center
        panoramaView.addSubview(lable)
//        panoramaView.moveNearCoordinate(CLLocationCoordinate2D(latitude: destinationLatitude!, longitude: destinationLongitude!))
    }

    func panoramaView(_ panoramaView: GMSPanoramaView, didTap point: CGPoint) {

    }

    func panoramaView(_ view: GMSPanoramaView, error: Error, onMoveToPanoramaID panoramaID: String) {

    }

    func panoramaViewDidStartRendering(_ panoramaView: GMSPanoramaView) {

    }

    func panoramaViewDidFinishRendering(_ panoramaView: GMSPanoramaView) {

    }

}
