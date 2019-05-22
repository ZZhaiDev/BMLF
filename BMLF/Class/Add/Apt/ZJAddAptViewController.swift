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
    let testButton: UIButton = {
       let b = UIButton()
        b.backgroundColor = .red
        return b
    }()
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3{
            return 245
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = ZJAddAptFooterView()
        return view
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return mapView
//    }
    
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
        self.tableView.tableHeaderView = mapView
        self.tableView.tableHeaderView?.frame.size.height = originalMapViewH
        
//        self.view.addSubview(mapView)
//        mapView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
//
//        self.view.addSubview(tableView)
//        tableView.backgroundColor = .clear
//        tableView.anchor(top: mapView.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: -600, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        tableView.contentInset = UIEdgeInsets(top: 600, left: 0, bottom: 0, right: 0)
//
//        self.view.bringSubviewToFront(mapView)
        
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
            +++ Section("Date")
            
            <<< DateInlineRow() {
                $0.title = "Start Date"
                $0.value = Date()
//                $0.value = "尽快"
            }
            <<< DateInlineRow() {
                $0.title = "End Date"
                $0.value = Date()
//                $0.value = "无"
            }
            +++ Section("Description")
            
            <<< TextRow() {
                $0.title = "Title"
                $0.placeholder = "Input Your Title"
            }
            <<< TextRow() {
                $0.title = "Description"
                $0.placeholder = "Input Your Title"
            }
            
            +++ Section("Contact")
            
            <<< TextRow() {
                $0.title = "Phone Number"
                $0.placeholder = "Input Your Phone Number"
            }
            <<< TextRow() {
                $0.title = "Email"
                $0.placeholder = "Input Your Email"
            }
            <<< TextRow() {
                $0.title = "Wechat"
                $0.placeholder = "Input Your Wechat"
            }
//            <<< TextRow() {
//                $0.cellProvider = CellProvider<ZJAddAptTitleAndSummar>(nibName: "ZJAddAptTitleAndSummary", bundle: Bundle.main)
//                $0.cell.height = { 300 }
//                }
//                .onChange { row in
//                    if let textView = row.cell.viewWithTag(99) as? UITextView {
//                        textView.text = row.cell.textField.text
//                    }
//            }
            +++ Section("Base")
            <<< TextRow() {
                $0.title = "Price"
                $0.placeholder = "Input Your Price"
            }
            <<< AlertRow<String>() {
                $0.title = "Type"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Type"
                $0.options = ["Renting", "Subleasing", "Find a Roommate", "Find a Room"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
            }
            <<< AlertRow<String>() {
                $0.title = "Room Type"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Room type"
                $0.options = ["Studio", "1b1b", "2b1b", "2b2b", "3b1b", "others"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
            }
            <<< AlertRow<String>() {
                $0.title = "Bathroom"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Bathroom"
                $0.options = ["Private", "Share"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
            }
            <<< AlertRow<String>() {
                $0.title = "Parking Lot"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Parking Lot"
                $0.options = ["Free Parking", "Paid Parking", "Free Parking On Street", "No Parking"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
            }
            
            <<< AlertRow<String>() {
                $0.title = "Washing Machine"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Washing Machine"
                $0.options = ["Indoor Washing Machine", "Share Washing Machine"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
        }
        <<< MultipleSelectorRow<String>() {
            $0.title = "Included"
            $0.options = ["Water Included", "Electricity Included", "WiFi Included", "Gym", "Furniture"]
            $0.value = []
            }
            .onPresent { from, to in
                to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(self.multipleSelectorDone(_:)))
        }
            
        <<< MultipleSelectorRow<String>() {
            $0.title = "Nearby"
            $0.options = ["School", "Subway", "bus", "Supermarket", "Restaurant", "Bar", "Park", "Lake"]
            $0.value = []
            }
            .onPresent { from, to in
                to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(self.multipleSelectorDone(_:)))
        }
            
        
        +++ Section("Requirement")
        <<< AlertRow<String>() {
                $0.title = "Lease period"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Lease period"
                $0.options = ["Long-term rental", "Short-term rental", "Both"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
            }
            <<< AlertRow<String>() {
                $0.title = "Gender"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Gender"
                $0.options = ["Boys only", "Girls only", "both"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
        }
            <<< AlertRow<String>() {
                $0.title = "Cooking"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Cooking"
                $0.options = ["Normal Cooking", "Less Cooking", "No Cooking"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
        }
            
        <<< AlertRow<String>() {
                $0.title = "Smoking"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Smoke"
                $0.options = ["No Smoking", "Normal Smoking"]
                $0.value = ""
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
        }
        
        <<< MultipleSelectorRow<String>() {
                $0.title = "Other Requirements"
                $0.options = ["Single Only", "Keep Clean", "Without Overnight Visitor", "Quiet", "No Party", "Not Staying up Late", "No Pets", "Love Pets"]
                $0.value = []
                }
                .onPresent { from, to in
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(self.multipleSelectorDone(_:)))
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
//        mapView.frame.origin.y = -scrollView.contentOffset.y - 600
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        ZJPrint(indexPath)
        
    }
    
    
    

}


