//
//  ZJAddAptViewControllerLayout.swift
//  BMLF
//
//  Created by zijia on 5/30/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import Eureka
import NVActivityIndicatorView

var optionalStr = "(Optional)"
var defalutValue = "empty"
var defalutServerValue = "Data unavailable"

private var uuid: String = defalutValue
var fulladdress: String = defalutValue
 var address: String = defalutValue
 var city: String = defalutValue
 var state: String = defalutValue
 var zipcode: String = defalutValue
private var submittime: String = "empty"
 var longitude: String = "0.0"
 var latitude: String = "0.0"

private var startDate: String = defalutValue
private var endDate: String = defalutValue
private var titleL: String = defalutValue
// swiftlint:disable identifier_name
var descriptionText_ = defalutValue
private var phoneNumber: String = defalutValue
private var email: String = defalutValue
private var wechat: String = defalutValue
private var price: String = defalutValue
private var category: String = defalutValue
private var houseType: String = defalutValue
private var roomType: String = defalutValue
private var bathroom: String = defalutValue
private var parkingLot: String = defalutValue
private var washingMachine: String = defalutValue
private var included: [String] = []
private var nearby: [String] = []
private var leasePeriod: String = defalutValue
private var gender: String = defalutValue
private var cooking: String = defalutValue
private var smoking: String = defalutValue
private var otherRequirements: [String] = []
private var images: [String] = []
private var video: String = defalutValue

extension ZJAddAptViewController: NVActivityIndicatorViewable {
    func nearbyDict() -> [[String: String]] {
        let nearbyCount = nearby.count
        var nearbyDict = [[String:String]]()
        for index in 0..<nearbyCount {
            var dict = [String: String]()
            dict["nearby"] = nearby[index]
            nearbyDict.append(dict)
        }
        return nearbyDict
    }

    func includedDict() -> [[String: String]] {
        let includedCount = included.count
        var includedDict = [[String:String]]()
        for index in 0..<includedCount {
            var dict = [String: String]()
            dict["included"] = included[index]
            includedDict.append(dict)
        }
        return includedDict
    }

    func otherRequirementsDict() -> [[String: String]] {
        let otherCount = otherRequirements.count
        var otherDict = [[String:String]]()
        for index in 0..<otherCount {
            var dict = [String: String]()
            dict["otherrequirement"] = otherRequirements[index]
            otherDict.append(dict)
        }
        return otherDict
    }

    func imagesDict() -> [[String: String]] {
        let imagesCount = images.count
        var imagesDict = [[String:String]]()
        for index in 0..<imagesCount {
            var dict = [String: String]()
            dict["image"] = images[index]
            imagesDict.append(dict)
        }
        return imagesDict
    }

    func currentTime() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.medium
        let now = dateformatter.string(from: Date())
        return now
    }

    fileprivate func checkSubmitValide() -> Bool {
        if fulladdress == defalutValue || titleL == defalutValue || phoneNumber == defalutValue || email == defalutValue || email == defalutValue || selectedItems.isEmpty {
            let alertVC = UIAlertController(title: "Warning", message: "Please Make Sure Your Address, Title, Phone Number, Email, Price and Photos are not Empty!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
            }
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true) {
            }
            return false
        }
        return true
    }

    @objc func submitfunc() {
        if checkSubmitValide() == false {return}
        let UUID = NSUUID().uuidString

        startAnimating(CGSize(width: 30, height: 30), message: "Uploading...", fadeInAnimation: nil)
        getImageUrlFromAWSS3(UUID: UUID) {
            ZJPrint(images)
            let form = self.fillOutForms(UUID: UUID)
            NetworkTools.requestData(.post, URLString: "\(baseAPI)api/v1/rental/house/", parameters: form) { (data) in
                guard let data = data else {
                    NVActivityIndicatorPresenter.sharedInstance.setMessage("Something is Wrong...")
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                        self.stopAnimating()
                        self.closefunc()
                        return
                    })
                    return
                }
                NVActivityIndicatorPresenter.sharedInstance.setMessage("Uploaded Successfully, Updating data...")

                if let rootVC = UIApplication.firstViewController() as? ZJRentAptViewController {
//                    rootVC.aptViewModel.loadApt { (_) in
//                        rootVC.listView.data = rootVC.aptViewModel.aptProperties
//                        //这个mapview会不会重复添加？
//                        rootVC.mapView.data = rootVC.aptViewModel.aptProperties
//                        self.stopAnimating()
//                        self.closefunc()
//                    }
                    
                    // 这里需要用 uuid 来call 用户提交的数据
                    rootVC.aptViewModel.loadAptByUUID(UUID: UUID, finished: { (aptProperties) in
                        rootVC.totalDatas.append(aptProperties)
                        rootVC.listView.data = rootVC.totalDatas
                        rootVC.mapView.data = [aptProperties]
                        self.stopAnimating()
                        self.closefunc()
                    })
                }
            }
        }
    }

    func fillOutForms(UUID: String) -> [String : Any] {
        let form = [
            "uuid": UUID,
            "category": category,
            "fulladdress": fulladdress,
            "address": address,
            "city": city,
            "state": state,
            "zipcode": zipcode,
            "submittime": currentTime(),
            "longitude": longitude,              //不能填string 只能填double？
            "latitude": latitude,
            "date": [
                "starttime": startDate,
                "endtime": endDate
            ],
            "description": [
                "title": titleL,
                "description": descriptionText_
            ],
            "contact": [
                "phonenumber": phoneNumber,
                "email": email,             //测试
                "wechat": wechat
            ],
            "base": [
                "price": price,
                "housetype": houseType,
                "roomtype": roomType,
                "bathroom": bathroom,
                "parkinglot": parkingLot,
                "washingmachine": washingMachine,
                "nearby": nearbyDict(),
                "included": includedDict()
            ],
            "requirement": [
                "leaseperiod": leasePeriod,
                "gender": gender,
                "cooking": cooking,
                "smoking": smoking,
                "otherrequirements": otherRequirementsDict()
            ],
            "images": imagesDict(),
            "videos": "test"
            ] as [String : Any]
        return form
    }

    func resetForms() {
        uuid = defalutValue
        fulladdress = defalutValue
        address = defalutValue
        city = defalutValue
        state = defalutValue
        zipcode = defalutValue
        submittime = defalutValue
        longitude = "0.0"
        latitude = "0.0"

        startDate = defalutValue
        endDate = defalutValue
        titleL = defalutValue
        descriptionText_ = defalutValue
        phoneNumber = defalutValue
        email = defalutValue
        wechat = defalutValue
        price = defalutValue
        category = defalutValue
        houseType = defalutValue
        roomType = defalutValue
        bathroom = defalutValue
        parkingLot = defalutValue
        washingMachine = defalutValue
        included = []
        nearby = []
        leasePeriod = defalutValue
        gender = defalutValue
        cooking = defalutValue
        smoking = defalutValue
        otherRequirements = []
        images = []
        video = defalutValue

        selectedItems = []
    }

    func getImageUrlFromAWSS3(UUID: String, finish: @escaping ()->Void) {
        if selectedItems.isEmpty {
            finish()
            return
        }
        for image in selectedItems {
            switch image {
            case .photo(p: let imageV):
                guard let imageName = imageV.asset?.value(forKey: "filename") else {return}
                ZJPrint(imageName)
                let url = "https://3dxcuahqad.execute-api.us-east-1.amazonaws.com/v1/uploadimage"
                let dict = ["filePath": "\(UUID)-\(imageName)", "contentType": "image/jpeg", "contentEncoding": "base64"]
                ApiService.callPost(url: URL(string: url)!, params: dict) { (arg0) in
                    let (message, data) = arg0
                    if message != "Success"{
                        ZJPrint("---------WRONG")
                        return
                    }
                    ZJPrint(message)
                    if let jsonData = data {
                        let str = String(data: jsonData, encoding: String.Encoding.utf8)!
                        ApiService.uploadToS3(image: imageV.image, urlString: str, completion: { (_, err) in
                            if err != nil {
                                ZJPrint(err)
                                return
                            }
//                            ZJPrint(responce!)
                            let urlStr = "https://blissmotors-web-upload.s3.amazonaws.com/bmlife/\(UUID)-\(imageName)"
                            images.append(urlStr)
                            if images.count == selectedItems.count {
                                finish()
                            }

                        })
                    }
                }
            case .video(_):
                break
            }
        }

    }
}

// MARK: - UISetup
extension ZJAddAptViewController {
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    func setupUI() {
        form.inlineRowHideOptions = InlineRowHideOptions.AnotherInlineRowIsShown.union(.FirstResponderChanges)
        form
            +++ Section(header: "Date", footer: "This section is shown only when 'Show Next Row' switch is enabled")

            <<< DateInlineRow {
                $0.title = "Start Date"
                let defaultV = Date()
                $0.value = defaultV
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = DateFormatter.Style.medium
                let now = dateformatter.string(from: defaultV)
                startDate = now
                }.onChange({ (date) in
                    if let value = date.value {
                        let dateformatter = DateFormatter()
                        dateformatter.dateStyle = DateFormatter.Style.medium
                        let now = dateformatter.string(from: value)
                        startDate = now
                    }
                })
            <<< SwitchRow("Show End Date") {
                $0.title = $0.tag
                }.onChange({ (bool) in
                    if let value = bool.value {
                        self.isShowedEndDate = value
                    }
                })
            <<< DateInlineRow {
                $0.title = "End Date"
                $0.value = Date()
                $0.hidden = .function(["Show End Date"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "Show End Date")
                    return row.value ?? false == false
                })
                }.onChange({ (date) in
                    if let value = date.value {
                        let dateformatter = DateFormatter()
                        dateformatter.dateStyle = DateFormatter.Style.medium
                        let now = dateformatter.string(from: value)
                        endDate = now
                    }

                })
            +++ Section("Description")

            <<< TextRow {
                $0.title = "Title"
                $0.placeholder = "Input Your Title"
                }.onChange({ (text) in
                    if let text =  text.value {
                        titleL = text
                    }
                })

            +++ Section { section in
                var customView = HeaderFooterView<MyCustomUIView>(.class)
                customView.height = {MyCustomUIView.cellHeight}
                customView.title = "Description"
                customView.onSetupView = { view, _ in
                    view.backgroundColor = .white
                }
                section.header = customView
            }

            +++ Section("Contact")

            <<< TextRow {
                $0.title = "Phone Number"
                $0.placeholder = "Input Your Phone Number"
                }.onChange({ (text) in
                    if let text = text.value {
                        phoneNumber = text
                    }
                })
            <<< TextRow {
                $0.title = "Email"
                $0.placeholder = "Input Your Email"
                }.onChange({ (text) in
                    if let text = text.value {
                        email = text
                    }
                })

            <<< TextRow {
                $0.title = "Wechat"
                $0.placeholder = optionalStr
                }.onChange({ (text) in
                    if let text = text.value {
                        wechat = text
                    }
                })

            +++ Section("Base")
            <<< TextRow {
                $0.title = "Price"
                $0.placeholder = "Input Your Price"
                }.onChange({ (text) in
                    if let text = text.value {
                        price = text
                    }
                })

            <<< AlertRow<String> {
                $0.title = "Category"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Category"
                $0.options = ["Leasing", "Subleasing", "Find a Roommate"]
                let defalutV = "Find a Roommate"
                $0.value = defalutV
                category = defalutV
//                $0.placeholder = "Input Your Category"
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent { _, to in
                    to.view.tintColor = .orange
                }.onChange({ (text) in
                    if let text = text.value {
                        category = text
                    }
                })
            <<< AlertRow<String> {
                $0.title = "Room Type"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Room type"
                $0.options = ["Studio", "1b1b", "2b1b", "2b2b", "3b1b", "3b2b", "4b4b", "Over 4 Bedrooms"]
                let defalutV = "2b1b"
                $0.value = defalutV
                roomType = defalutV
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent { _, to in
                    to.view.tintColor = .orange
                }.onChange({ (text) in
                    if let text = text.value {
                        roomType = text
                    }
                })

            <<< AlertRow<String> {
                $0.title = "House Type"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "House type"
                $0.options = ["Apartment", "Condo", "House", "Town House"]
                let defalutV = "Apartment"
                $0.value = defalutV
                houseType = defalutV
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent { _, to in
                    to.view.tintColor = .orange
                }.onChange({ (text) in
                    if let text = text.value {
                        houseType = text
                    }
                })

            <<< AlertRow<String> {
                $0.title = "Bathroom"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Bathroom"
                $0.options = ["Private", "Share"]
                let defalutV = "Share"
                $0.value = defalutV
                bathroom = defalutV
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent { _, to in
                    to.view.tintColor = .orange
                }.onChange({ (text) in
                    if let text = text.value {
                        bathroom = text
                    }
                })

            <<< AlertRow<String> {
                $0.title = "Parking Lot"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Parking Lot"
                $0.options = ["Free Parking", "Paid Parking", "Free Parking On Street", "No Parking"]
                let defalutV = "No Parking"
                $0.value = defalutV
                parkingLot = defalutV
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent { _, to in
                    to.view.tintColor = .orange
                }.onChange({ (text) in
                    if let text = text.value {
                        parkingLot = text
                    }
                })

            <<< AlertRow<String> {
                $0.title = "Washing Machine"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Washing Machine"
                $0.options = ["Indoor Washing Machine", "Share Washing Machine"]
                let defalutV = "Share Washing Machine"
                $0.value = defalutV
                washingMachine = defalutV
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent { _, to in
                    to.view.tintColor = .orange
                }.onChange({ (text) in
                    if let text = text.value {
                        washingMachine = text
                    }
                })

            <<< MultipleSelectorRow<String> {
                $0.title = "Included"
                $0.options = ["Water Included", "Electricity Included", "WiFi Included", "Gym", "Furniture"]
                let defalutV = ["Water Included", "Electricity Included", "WiFi Included"]
                $0.value = Set(defalutV)
                included = defalutV
                }
                .onPresent { from, to in
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(self.multipleSelectorDone(_:)))
                }.onChange({ (text) in
                    if let text = text.value {
                        included = Array(text)
                    }
                })

            <<< MultipleSelectorRow<String> {
                $0.title = "Nearby"
                $0.options = ["School", "Subway", "bus", "Supermarket", "Restaurant", "Bar", "Park", "Lake"]
                let defalutV = ["Restaurant"]
                $0.value = Set(defalutV)
                nearby = defalutV
                }
                .onPresent { from, to in
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(self.multipleSelectorDone(_:)))
                }.onChange({ (text) in
                    if let text = text.value {
                        nearby = Array(text)
                    }
                })

            +++ Section("Requirement")
            <<< AlertRow<String> {
                $0.title = "Lease period"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Lease period"
                $0.options = ["Long-term rental", "Short-term rental", "Both"]
                let defalutV = "Both"
                $0.value = defalutV
                leasePeriod = defalutV
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent { _, to in
                    to.view.tintColor = .orange
                }.onChange({ (text) in
                    if let text = text.value {
                        leasePeriod = text
                    }
                })

            <<< AlertRow<String> {
                $0.title = "Gender"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Gender"
                $0.options = ["Boys only", "Girls only", "both"]
                let defalutV = "Both"
                $0.value = defalutV
                gender = defalutV
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent { _, to in
                    to.view.tintColor = .orange
                }.onChange({ (text) in
                    if let text = text.value {
                        gender = text
                    }
                })

            <<< AlertRow<String> {
                $0.title = "Cooking"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Cooking"
                $0.options = ["Normal Cooking", "Less Cooking", "No Cooking"]
                let defalutV = "Normal Cooking"
                $0.value = defalutV
                cooking = defalutV
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent { _, to in
                    to.view.tintColor = .orange
                }.onChange({ (text) in
                    if let text = text.value {
                        cooking = text
                    }
                })

            <<< AlertRow<String> {
                $0.title = "Smoking"
                $0.cancelTitle = "Exit"
                $0.selectorTitle = "Smoke"
                $0.options = ["No Smoking", "Normal Smoking"]
                let defalutV = "Normal Smoking"
                $0.value = defalutV
                smoking = defalutV
                }.onChange { row in
                    print(row.value ?? "No Value")
                }
                .onPresent { _, to in
                    to.view.tintColor = .orange
                }.onChange({ (text) in
                    if let text = text.value {
                        smoking = text
                    }
                })

            <<< MultipleSelectorRow<String> {
                $0.title = "Other Requirements"
                $0.options = ["Single Only", "Keep Clean", "Without Overnight Visitor", "Quiet", "No Party", "Not Staying up Late", "No Pets", "Love Pets"]
                let defalutV = ["Quiet", "Not Staying up Late"]
                $0.value = Set(defalutV)
                otherRequirements = defalutV
                }
                .onPresent { from, to in
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(self.multipleSelectorDone(_:)))
                }.onChange({ (text) in
                    if let text = text.value {
                        otherRequirements = Array(text)
                    }
                })

        navigationOptions = RowNavigationOptions.Enabled.union(.SkipCanNotBecomeFirstResponderRow)
        navigationOptionsBackup = navigationOptions
    }
}
