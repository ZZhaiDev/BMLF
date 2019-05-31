//
//  ZJAddAptViewControllerLayout.swift
//  BMLF
//
//  Created by zijia on 5/30/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import Eureka

private var uuid: String = "empty"
var fulladdress: String = "empty"
private var address: String = "empty"
private var city: String = "empty"
private var state: String = "empty"
private var zipcode: String = "empty"
private var submittime: String = "empty"
private var longitude: String = "empty"
private var latitude: String = "empty"

private var startDate: String = "empty"
private var endDate: String = "empty"
private var titleL: String = "empty"
var descriptionText_ = "empty"
private var phoneNumber: String = "empty"
private var email: String = "empty"
private var wechat: String = "empty"
private var price: String = "empty"
private var type: String = "empty"
private var roomType: String = "empty"
private var bathroom: String = "empty"
private var parkingLot: String = "empty"
private var washingMachine: String = "empty"
private var included: [String] = []
private var nearby: [String] = []
private var leasePeriod: String = "empty"
private var gender: String = "empty"
private var cooking: String = "empty"
private var smoking: String = "empty"
private var otherRequirements: [String] = []
private var images: [String] = []
private var video: String = "empty"



extension ZJAddAptViewController{
    func nearbyDict() -> [[String: String]]{
        let nearbyCount = nearby.count
        var nearbyDict = [[String:String]]()
        for i in 0..<nearbyCount{
            var dict = [String: String]()
            dict["id"] = "1"
            dict["nearby"] = nearby[i]
            nearbyDict.append(dict)
        }
        return nearbyDict
    }
    
    @objc func submitfunc(){
        let UUID = NSUUID().uuidString
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.medium
        let now = dateformatter.string(from: Date())
        ZJPrint(now)
        
        getImageUrlFromAWSS3()
        
        ZJPrint(nearbyDict())
        ZJPrint(fulladdress)
        let para = [
            "uuid": UUID,
            "fulladdress": fulladdress,
            "address": address,
            "city": city,
            "state": state,
            "zipcode": zipcode,
            "submittime": now,
            "longitude": "20.231",              //不能填string 只能填double？
            "latitude": "62.21",
            "date": [
                "id": 1,
                "starttime": startDate,
                "endtime": endDate
            ],
            "description": [
                "id": 1,
                "title": titleL,
                "description": descriptionText_
            ],
            "contact": [
                "id": 1,
                "phonenumber": phoneNumber,
                "email": email,             //测试
                "wechat": wechat
            ],
            "base": [
                "id": 1,
                "price": price,
                "housetype": type,
                "roomtype": roomType,
                "bathroom": bathroom,
                "parkinglot": parkingLot,
                "washingmachine": washingMachine,
                "nearby": nearbyDict(),
                "included": [
                    [
                        "id": 1,
                        "included": "test"
                    ]
                ]
            ],
            "requirement": [
                "id": 1,
                "leaseperiod": leasePeriod,
                "gender": gender,
                "cooking": cooking,
                "smoking": smoking,
                "otherrequirements": [
                    [
                        "id": 1,
                        "otherrequirement": "test"
                    ]
                ]
            ],
            "images": [
                [
                    "id": 1,
                    "image": "test"
                ]
            ],
            "videos": "test"
            ] as [String : Any]
        NetworkTools.requestData(.post, URLString: "http://aca33a60.ngrok.io/api/v1/rental/house/", parameters: para) { (data) in
            ZJPrint(data)
        }
        
    }
    
    func getImageUrlFromAWSS3(){
        for image in selectedItems{
            switch image{
            case .photo(p: let imageV):
                guard let imageName = imageV.asset?.value(forKey: "filename") else {return}
                ZJPrint(imageName)
                let url = "https://3dxcuahqad.execute-api.us-east-1.amazonaws.com/v1/uploadimage"
                let dict = ["filePath": imageName, "contentType": "image/jpeg", "contentEncoding": "base64"]
                ApiService.callPost(url: URL(string: url)!, params: dict) { (arg0) in
                    let (message, data) = arg0
                    ZJPrint(message)
                    if let jsonData = data{
                        let str = String(data: jsonData, encoding: String.Encoding.utf8)!
                        ApiService.uploadToS3(image: imageV.image, urlString: str, completion: { (responce, err) in
                            if err != nil{
                                ZJPrint(err)
                                return
                            }
                            ZJPrint(responce!)
                            
                        })
                    }
                }
            case .video(let _):
                break
            }
        }
    }
}


extension ZJAddAptViewController{
    func setup(){
        
        form.inlineRowHideOptions = InlineRowHideOptions.AnotherInlineRowIsShown.union(.FirstResponderChanges)
        form
            +++ Section(header: "Date", footer: "This section is shown only when 'Show Next Row' switch is enabled")
            
            <<< DateInlineRow() {
                $0.title = "Start Date"
                $0.value = Date()
                //                $0.value = "尽快"
                }.onChange({ (date) in
                    if let value = date.value{
                        let dateformatter = DateFormatter()
                        dateformatter.dateStyle = DateFormatter.Style.medium
                        let now = dateformatter.string(from: value)
                        startDate = now
                    }
                })
            <<< SwitchRow("Show End Date"){
                $0.title = $0.tag
                }.onChange({ (bool) in
                    if let value = bool.value{
                        self.isShowedEndDate = value
                    }
                })
            <<< DateInlineRow() {
                $0.title = "End Date"
                $0.value = Date()
                $0.hidden = .function(["Show End Date"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "Show End Date")
                    return row.value ?? false == false
                })
                }.onChange({ (date) in
                    if let value = date.value{
                        let dateformatter = DateFormatter()
                        dateformatter.dateStyle = DateFormatter.Style.medium
                        let now = dateformatter.string(from: value)
                        endDate = now
                    }
                    
                })
            +++ Section("Description")
            
            <<< TextRow() {
                $0.title = "Title"
                $0.placeholder = "Input Your Title"
                }.onChange({ (text) in
                    if let text =  text.value{
                        titleL = text
                    }
                })
            
            +++ Section(){ section in
                var customView = HeaderFooterView<MyCustomUIView>(.class)
                customView.height = {MyCustomUIView.cellHeight}
                customView.title = "Description"
                customView.onSetupView = { view, _ in
                    view.backgroundColor = .white
                }
                section.header = customView
            }
            
            +++ Section("Contact")
            
            <<< TextRow() {
                $0.title = "Phone Number"
                $0.placeholder = "Input Your Phone Number"
                }.onChange({ (text) in
                    if let text = text.value{
                        phoneNumber = text
                    }
                })
            <<< TextRow() {
                $0.title = "Email"
                $0.placeholder = "Input Your Email"
                }.onChange({ (text) in
                    if let text = text.value{
                        email = text
                    }
                })
            
            <<< TextRow() {
                $0.title = "Wechat"
                $0.placeholder = "Input Your Wechat"
                }.onChange({ (text) in
                    if let text = text.value{
                        wechat = text
                    }
                })
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
                }.onChange({ (text) in
                    if let text = text.value{
                        price = text
                    }
                })
            
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
                }.onChange({ (text) in
                    if let text = text.value{
                        type = text
                    }
                })
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
                }.onChange({ (text) in
                    if let text = text.value{
                        roomType = text
                    }
                })
            
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
                }.onChange({ (text) in
                    if let text = text.value{
                        bathroom = text
                    }
                })
            
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
                }.onChange({ (text) in
                    if let text = text.value{
                        parkingLot = text
                    }
                })
            
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
                }.onChange({ (text) in
                    if let text = text.value{
                        washingMachine = text
                    }
                })
            
            <<< MultipleSelectorRow<String>() {
                $0.title = "Included"
                $0.options = ["Water Included", "Electricity Included", "WiFi Included", "Gym", "Furniture"]
                $0.value = []
                }
                .onPresent { from, to in
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(self.multipleSelectorDone(_:)))
                }.onChange({ (text) in
                    if let text = text.value{
                        included = Array(text)
                    }
                })
            
            <<< MultipleSelectorRow<String>() {
                $0.title = "Nearby"
                $0.options = ["School", "Subway", "bus", "Supermarket", "Restaurant", "Bar", "Park", "Lake"]
                $0.value = []
                }
                .onPresent { from, to in
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(self.multipleSelectorDone(_:)))
                }.onChange({ (text) in
                    if let text = text.value{
                        nearby = Array(text)
                    }
                })
            
            
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
                }.onChange({ (text) in
                    if let text = text.value{
                        leasePeriod = text
                    }
                })
            
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
                }.onChange({ (text) in
                    if let text = text.value{
                        gender = text
                    }
                })
            
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
                }.onChange({ (text) in
                    if let text = text.value{
                        cooking = text
                    }
                })
            
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
                }.onChange({ (text) in
                    if let text = text.value{
                        smoking = text
                    }
                })
            
            <<< MultipleSelectorRow<String>() {
                $0.title = "Other Requirements"
                $0.options = ["Single Only", "Keep Clean", "Without Overnight Visitor", "Quiet", "No Party", "Not Staying up Late", "No Pets", "Love Pets"]
                $0.value = []
                }
                .onPresent { from, to in
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(self.multipleSelectorDone(_:)))
                }.onChange({ (text) in
                    if let text = text.value{
                        otherRequirements = Array(text)
                    }
                })
        
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
}
