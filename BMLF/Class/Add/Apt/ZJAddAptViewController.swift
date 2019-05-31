//
//  ZJAddAptViewController.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/16/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import Eureka




var originalMapViewH: CGFloat = 245

class ZJAddAptViewController: FormViewController {
    
    var isShowedEndDate = false
    
    let testButton: UIButton = {
       let b = UIButton()
        b.backgroundColor = .red
        return b
    }()
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 5{
            return 245
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = ZJAddAptFooterView()
        return view
    }
    
    var navigationOptionsBackup : RowNavigationOptions?
    fileprivate lazy var mainView : ZJAddAptMainView = {
        let mv = ZJAddAptMainView()
        return mv
    }()
    
    fileprivate lazy var mapView: ZJAddAptMapView = {
        let mv = ZJAddAptMapView()
//        mv.backgroundColor = .red
        return mv
    }()
    
    let tbutton: UIButton = {
       let b = UIButton()
        b.backgroundColor = .red
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closefunc))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitfunc))
        
        self.tableView.tableHeaderView = mapView
        self.tableView.tableHeaderView?.frame.size.height = originalMapViewH
        self.tableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
//        self.tableView.backgroundColor = .blue
        
        setup()
        
    }
    
    
    @objc func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
//    override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {
//        if row.section === form[0] {
//            print("Single Selection:\((row.section as! SelectableSection<ImageCheckRow<String>>).selectedRow()?.baseValue ?? "No row selected")")
//        }
//        else if row.section === form[1] {
//            print("Mutiple Selection:\((row.section as! SelectableSection<ImageCheckRow<String>>).selectedRows().map({$0.baseValue}))")
//        }
//    }
    
    @objc fileprivate func closefunc(){
        self.dismiss(animated: true) {
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        ZJPrint(scrollView.contentOffset.y)
//        mapView.frame.origin.y = -scrollView.contentOffset.y - 600
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        ZJPrint(indexPath)
        
    }
    
    
    

}


