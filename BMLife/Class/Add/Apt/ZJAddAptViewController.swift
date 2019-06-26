//
//  ZJAddAptViewController.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/16/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import Eureka
import NVActivityIndicatorView

var originalMapViewH: CGFloat = 245

class ZJAddAptViewController: FormViewController, NVActivityIndicatorViewable {

    var isShowedEndDate = false
    var navigationOptionsBackup : RowNavigationOptions?
    
    let testButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .red
        return button
    }()

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 5 {
            return 245
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = ZJAddAptFooterView()
        return view
    }

    
    fileprivate lazy var mainView : ZJAddAptMainView = {
        let view = ZJAddAptMainView()
        return view
    }()

    fileprivate lazy var mapView: ZJAddAptMapView = {
        let view = ZJAddAptMapView()
        return view
    }()

    let tbutton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .red
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .orange
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closefunc))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitfunc))
        self.tableView.tableHeaderView = mapView
        self.tableView.tableHeaderView?.frame.size.height = originalMapViewH
        self.tableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        setupUI()
    }

    @objc func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }

    @objc func closefunc() {
        self.dismiss(animated: true) {
            self.resetForms()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        ZJPrint(indexPath)
    }

}
