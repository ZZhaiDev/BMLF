//
//  ZJAddAptViewController.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/16/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import Eureka

class ZJAddAptViewController: FormViewController {
    let testButton: UIButton = {
       let b = UIButton()
        b.backgroundColor = .red
        return b
    }()
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1{
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
        //        let mv = ZJAddAptMapView(frame: CGRect(x: 0, y: -250, width: zjScreenWidth, height: originalMapViewH))
        let mv = ZJAddAptMapView()
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
        
        self.view.addSubview(mapView)
        mapView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        self.view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.anchor(top: mapView.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: -600, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //        collectionView.fillSuperview()
        tableView.contentInset = UIEdgeInsets(top: 600, left: 0, bottom: 0, right: 0)
        
        self.view.bringSubviewToFront(mapView)
        
//        tableView.addSubview(tbutton)
//        tbutton.anchor(top: tableView.bottomAnchor, left: tableView.leftAnchor, bottom: nil, right: tableView.rightAnchor, paddingTop: tableView.frame.size.height-350, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        setup()
//        self.view.addSubview(mainView)
//        mainView.fillSuperview()
        
    }
    
    func setup(){
        
//        let oceans = ["Arctic", "Atlantic", "Indian", "Pacific", "Southern"]
//        form +++ SelectableSection<ImageCheckRow<String>>("And which of the following oceans have you taken a bath in?", selectionType: .multipleSelection)
//        for option in oceans {
//            form.last! <<< ImageCheckRow<String>(option){ lrow in
//                lrow.title = option
//                lrow.selectableValue = option
//                lrow.value = nil
//                }.cellSetup { cell, _ in
//                    cell.trueImage = UIImage(named: "selectedRectangle")!
//                    cell.falseImage = UIImage(named: "unselectedRectangle")!
//                    cell.accessoryType = .checkmark
//            }
//        }
        
        form.inlineRowHideOptions = InlineRowHideOptions.AnotherInlineRowIsShown.union(.FirstResponderChanges)
        form
            +++ Section("日期")
            
            <<< DateInlineRow() {
                $0.title = "开始时间"
                $0.value = Date()
            }
            <<< DateInlineRow() {
                $0.title = "结束日期"
                $0.value = Date()
            }
            
            +++ Section("基础")
            <<< AlertRow<String>() {
                $0.title = "房型"
                $0.cancelTitle = "退出"
                $0.selectorTitle = "房型"
                $0.options = ["Studio", "一室一厅", "二室一厅", "三室一厅", "其他"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
            }
            <<< AlertRow<String>() {
                $0.title = "卫生间"
                $0.cancelTitle = "退出"
                $0.selectorTitle = "卫生间"
                $0.options = ["Private", "Share"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
            }
            <<< AlertRow<String>() {
                $0.title = "停车位"
                $0.cancelTitle = "退出"
                $0.selectorTitle = "停车位"
                $0.options = ["免费停车位", "付费停车位", "免费街趴", "没有停车位"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
            }
            <<< AlertRow<String>() {
                $0.title = "洗衣机"
                $0.cancelTitle = "退出"
                $0.selectorTitle = "洗衣机"
                $0.options = ["室内洗衣机", "公用投币洗衣机"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
        }
            <<< AlertRow<String>() {
                $0.title = "健身房"
                $0.cancelTitle = "退出"
                $0.selectorTitle = "健身房"
                $0.options = ["有", "无"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
        }
        <<< AlertRow<String>() {
                $0.title = "租期"
                $0.cancelTitle = "退出"
                $0.selectorTitle = "租期"
                $0.options = ["长租", "短租", "长短租都可"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
            }
            <<< AlertRow<String>() {
                $0.title = "性别要求"
                $0.cancelTitle = "退出"
                $0.selectorTitle = "性别"
                $0.options = ["男", "女", "男女都行"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
        }
            <<< AlertRow<String>() {
                $0.title = "做饭"
                $0.cancelTitle = "退出"
                $0.selectorTitle = "做饭"
                $0.options = ["正常", "少做饭", "不能做饭"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
        }
            
        <<< AlertRow<String>() {
                $0.title = "吸烟"
                $0.cancelTitle = "退出"
                $0.selectorTitle = "吸烟"
                $0.options = ["可以吸烟", "禁止吸烟"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
        }
        
        navigationOptions = RowNavigationOptions.Enabled.union(.SkipCanNotBecomeFirstResponderRow)
        navigationOptionsBackup = navigationOptions
        
//        form = Section(header: "Settings", footer: "These settings change how the navigation accessory view behaves")
//        form = Section(header: "Settings")
//           +++ Section("基础1")
//            <<< SwitchRow("set_none") { [weak self] in
//                $0.title = "Navigation accessory view"
//                $0.value = self?.navigationOptions != .Disabled
//                }.onChange { [weak self] in
//                    if $0.value ?? false {
//                        self?.navigationOptions = self?.navigationOptionsBackup
//                        self?.form.rowBy(tag: "set_disabled")?.baseValue = self?.navigationOptions?.contains(.StopDisabledRow)
//                        self?.form.rowBy(tag: "set_skip")?.baseValue = self?.navigationOptions?.contains(.SkipCanNotBecomeFirstResponderRow)
//                        self?.form.rowBy(tag: "set_disabled")?.updateCell()
//                        self?.form.rowBy(tag: "set_skip")?.updateCell()
//                    }
//                    else {
//                        self?.navigationOptionsBackup = self?.navigationOptions
//                        self?.navigationOptions = .Disabled
//                    }
//            }
//
//            <<< CheckRow("set_disabled") { [weak self] in
//                $0.title = "Stop at disabled row"
//                $0.value = self?.navigationOptions?.contains(.StopDisabledRow)
//                $0.hidden = "$set_none == false" // .Predicate(NSPredicate(format: "$set_none == false"))
//                }.onChange { [weak self] row in
//                    if row.value ?? false {
//                        self?.navigationOptions = self?.navigationOptions?.union(.StopDisabledRow)
//                    }
//                    else{
//                        self?.navigationOptions = self?.navigationOptions?.subtracting(.StopDisabledRow)
//                    }
//            }
//
//            <<< CheckRow("set_skip") { [weak self] in
//                $0.title = "Skip non first responder view"
//                $0.value = self?.navigationOptions?.contains(.SkipCanNotBecomeFirstResponderRow)
//                $0.hidden = "$set_none  == false"
//                }.onChange { [weak self] row in
//                    if row.value ?? false {
//                        self?.navigationOptions = self?.navigationOptions?.union(.SkipCanNotBecomeFirstResponderRow)
//                    }
//                    else{
//                        self?.navigationOptions = self?.navigationOptions?.subtracting(.SkipCanNotBecomeFirstResponderRow)
//                    }
//        }
//        +++
//        NameRow() { $0.title = "Your name:" }
        
        
        
        
        
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
        ZJPrint(scrollView.contentOffset.y)
        mapView.frame.origin.y = -scrollView.contentOffset.y - 600
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        ZJPrint(indexPath)
        
    }
    
    
    

}


