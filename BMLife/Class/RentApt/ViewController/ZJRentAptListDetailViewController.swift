//
//  ZJRentAptListDetainViewController.swift
//  BMLF
//
//  Created by Zijia Zhai on 5/21/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import MapKit

let zjCycleViewH: CGFloat = zjScreenHeight * 3 / 8

private let cateViewH: CGFloat = 80
private let zjHeaderViewH: CGFloat = 50
private let zjItemMargin : CGFloat = 10

private let cellId = "cellId"
private let titleCellId = "titleCellId"
private let cateCellId = "cateCellId"
private let headerCellId = "headerCellId"
private let baseCellId = "baseCellId"
private let requirementCellId = "requirementCellId"
private let requirementCellId1 = "requirementCellId1"
private let requirementCellId2 = "requirementCellId2"
private let descriptionCellId = "descriptionCellId"
private let contactCellId = "contactCellId"
class ZJRentAptListDetailViewController: ZJBaseViewController {

    var data = AddAptProperties() {
        didSet {
            if let images = data.images {
                cycleView.data = images
            }
            baseValue.append(data.fulladdress ?? "")
            let price = (data.base?.price ?? "") + "/m"
            baseValue.append(price)
            baseValue.append(data.category ?? "")
            baseValue.append(data.base?.housetype ?? "")
            baseValue.append(data.base?.roomtype ?? "")
            let bathroom = (data.base?.bathroom ?? "") + " Bathroom"
            baseValue.append(bathroom)
            baseValue.append(data.base?.parkinglot ?? "")
            baseValue.append(data.base?.washingmachine ?? "")
            if let requirement = data.requirement, let others = requirement.otherrequirements {
                for other in others {
                    requirementTitles.append(other.otherrequirement ?? "")
                }
                if let leasingP = requirement.leaseperiod, leasingP != "Both"{
                    requirementTitles.insert(leasingP, at: 0)
                }
                if let cooking = requirement.cooking, cooking != "Normal Cooking"{
                    requirementTitles.insert(cooking, at: 0)
                }
                if let smoking = requirement.smoking, smoking == "No Smoking"{
                    requirementTitles.insert(smoking, at: 0)
                }
                if let gender = requirement.gender, gender != "Both"{
                    requirementTitles.insert(gender, at: 0)
                }
            }
            if let base = data.base, let include = base.included {
                for temp in include {
                    includeTitles.append(temp.included ?? "")
                }
            }
            if let base = data.base, let nearby = base.nearby {
                for temp in nearby {
                    closeTitles.append(temp.nearby ?? "")
                }
            }
            if let start = data.date?.starttime {
                baseValue.append(start)
            }
            if let description = data.description, let des = description.description {
                descriptionVaule = des
            }
            getDrivingDistanceAndTime { (distance, time, error) in
                if error != nil {
                    self.collectionView.reloadData()
                    return
                }
                guard let distance = distance, let time = time else {
                    self.collectionView.reloadData()
                    return
                }
                self.basekey.append("Distance")
                self.basekey.append("Driving Time")
                let distanteValue = "\(distance) miles"
                let timeValue = "\(time) minutes"
                self.baseValue.append(distanteValue)
                self.baseValue.append(timeValue)
                self.collectionView.reloadData()
            }
        }
    }

    var descriptionVaule = defalutValue
    var requiredmentCellHeight: CGFloat = 100
    
    var titleArr = ["", "", "Base", "Requirement", "Included", "Nearby", "Description", "Contact", ""]
    var basekey = ["Address", "Price", "Category", "House Type", "Room Type",  "Bathroom", "Parking", "Washer", "Start Date"]
    var baseValue = [String]()
    var requirementTitles = [String]()
    var includeTitles = [String]()
    var closeTitles = [String]()

    let cycleView: RecommendCycleView = {
        let view = RecommendCycleView.recommendCycleView()
        view.frame = CGRect(x: 0, y: -(zjCycleViewH+zjStatusHeight+zjNavigationBarHeight), width: zjScreenWidth, height: zjCycleViewH+zjStatusHeight+zjNavigationBarHeight)
        return view
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: zjScreenWidth, height: zjHeaderViewH)
        layout.minimumInteritemSpacing = zjItemMargin
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: zjItemMargin, bottom: 0, right: zjItemMargin)
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        view.register(ZJRentAptListDetailBaseCell.self, forCellWithReuseIdentifier: baseCellId)
        view.register(ZJRentAptListDetailRequirementCell.self, forCellWithReuseIdentifier: requirementCellId)
        view.register(ZJRentAptListDetailRequirementCell1.self, forCellWithReuseIdentifier: requirementCellId1)
        view.register(ZJRentAptListDetailRequirementCell2.self, forCellWithReuseIdentifier: requirementCellId2)
        view.register(ZJRentAptListDetailTitleViewCell.self, forCellWithReuseIdentifier: titleCellId)
        view.register(ZJRentAptListDetailCatrgoriesCell.self, forCellWithReuseIdentifier: cateCellId)
        view.register(ZJRentAptListDetailDescriptionCell.self, forCellWithReuseIdentifier: descriptionCellId)
        view.register(ZJRentAptListDetailContactCell.self, forCellWithReuseIdentifier: contactCellId)
        view.backgroundColor = .clear
        view.register(ZJRentAptListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    func hideNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    fileprivate func showNavigationBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .orange
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar()
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        collectionView.contentInset = UIEdgeInsets(top: zjCycleViewH, left: 0, bottom: 0, right: 0)
        collectionView.addSubview(cycleView)
    }

    deinit {
        ZJPrint("12312312")
    }

    fileprivate func getDrivingDistanceAndTime(finished: @escaping (_ distance: String?,_ time: String?, _ error: Error?)->Void) {
        guard let userCoordinate = userCurrentCoordinate else {return}
        guard let lat = Double(data.latitude!) else {return}
        guard let lon = Double(data.longitude!) else {return}
        let request         = MKDirections.Request()
        let sourceP         = CLLocationCoordinate2DMake(userCoordinate.latitude, userCoordinate.longitude)
        let destP           = CLLocationCoordinate2DMake(lat, lon)
        let source          = MKPlacemark(coordinate: sourceP)
        let destination     = MKPlacemark(coordinate: destP)
        request.source      = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = MKDirectionsTransportType.automobile
        request.requestsAlternateRoutes = true
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if error != nil {
                finished(nil, nil, error)
            }
            if let response = response, let route = response.routes.first {
                let distane = String(format: "%.1f", route.distance/1600)
                let time = String(Int(route.expectedTravelTime/60 + 0.5))
                finished(distane, time, error)
            } else {
                finished(nil, nil, error)
            }
        }
    }
}

extension ZJRentAptListDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return titleArr.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 2 {
            ZJPrint(baseValue.count)
            ZJPrint(basekey.count)
            return min(basekey.count, baseValue.count)
        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: zjScreenWidth, height: ZJRentAptListDetailTitleViewCell.selfHeight)
        } else if indexPath.section == 1 {
            return CGSize(width: zjScreenWidth, height: cateViewH)
        } else if indexPath.section == 2 {
            return CGSize(width: zjScreenWidth, height: 25)
        } else if indexPath.section == 3 {
            ZJPrint(requirementTitles)
            return CGSize(width: zjScreenWidth, height: calcuatedHeight(titles: requirementTitles))
        } else if indexPath.section == 4 {
            return CGSize(width: zjScreenWidth, height: calcuatedHeight(titles: includeTitles))
        } else if indexPath.section == 5 {
            return CGSize(width: zjScreenWidth, height: calcuatedHeight(titles: closeTitles))
        } else if indexPath.section == 6 {
            if descriptionVaule == defalutValue || descriptionVaule == defalutServerValue {
                return CGSize(width: zjScreenWidth, height: 0.001)
            }
            let approximateWidthOfContent = view.frame.width - 15
            let height = calculateHeight(width: approximateWidthOfContent, textFont: UIFont.systemFont(ofSize: 16), text: descriptionVaule)
            return CGSize(width: approximateWidthOfContent, height: height+20)
        } else if indexPath.section == 7 {
            return CGSize(width: zjScreenWidth, height: ZJRentAptListDetailContactCell.selfHeight)
        }
        return CGSize(width: zjScreenWidth, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
        } else if section == 1 {
            return .zero
        } else if section == 6 {
            if descriptionVaule == defalutValue || descriptionVaule == defalutServerValue  {
                return .zero
            }
            return CGSize(width: zjScreenWidth, height: 44)
        }
        return CGSize(width: zjScreenWidth, height: 44)
    }

    // swiftlint:disable function_body_length
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            // swiftlint:disable: force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: titleCellId, for: indexPath) as! ZJRentAptListDetailTitleViewCell
            cell.data = data
            return cell
        case 1:
            // swiftlint:disable: force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cateCellId, for: indexPath) as! ZJRentAptListDetailCatrgoriesCell
            if let lon = data.longitude, let lati = data.latitude {
                cell.coordinate = CLLocationCoordinate2D(latitude: Double(lati)!, longitude: Double(lon)!)
            }
            return cell
        case 2:
            // swiftlint:disable: force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: baseCellId, for: indexPath) as! ZJRentAptListDetailBaseCell
            cell.firstLabel.text = "\(basekey[indexPath.row])" + ":"
            cell.secondtLabel.text = "\(baseValue[indexPath.row])"
            return cell
        case 3:
            // swiftlint:disable: force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: requirementCellId, for: indexPath) as! ZJRentAptListDetailRequirementCell
            cell.ynCategoryButtonType = .colorful
            cell.titles = requirementTitles
            return cell
        case 4:
            // swiftlint:disable: force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: requirementCellId1, for: indexPath) as! ZJRentAptListDetailRequirementCell1
            cell.titles = includeTitles
            return cell
        case 5:
            // swiftlint:disable: force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: requirementCellId2, for: indexPath) as! ZJRentAptListDetailRequirementCell2
            cell.titles = closeTitles
            return cell
        case 6:
            if descriptionVaule == defalutValue {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
                return cell
            }
            // swiftlint:disable: force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionCellId, for: indexPath) as! ZJRentAptListDetailDescriptionCell
            cell.data = descriptionVaule
            return cell
        case 7:
            // swiftlint:disable: force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contactCellId, for: indexPath) as! ZJRentAptListDetailContactCell
            cell.data = data.contact
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       // swiftlint:disable: force_cast
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as! ZJRentAptListHeaderView
        headerView.label.text = titleArr[indexPath.section]
        return headerView
    }

    func calcuatedHeight(titles: [String]) -> CGFloat {
        var ynCategoryButtons = [YNCategoryButton]()
        let margin: CGFloat = 15
        var formerWidth: CGFloat = 15
        var formerHeight: CGFloat = 0
        let font = UIFont.systemFont(ofSize: 12)
        let userAttributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor: UIColor.gray]
        for index in 0..<titles.count {
            let size = titles[index].size(withAttributes: userAttributes)
            if index > 0 {
                formerWidth = ynCategoryButtons[index-1].frame.size.width + ynCategoryButtons[index-1].frame.origin.x + 10
                if formerWidth + size.width + margin > UIScreen.main.bounds.width {
                    formerHeight += ynCategoryButtons[index-1].frame.size.height + 10
                    formerWidth = margin
                }
            }
            let button = YNCategoryButton(frame: CGRect(x: formerWidth, y: formerHeight, width: size.width + 10, height: size.height + 10))
            ynCategoryButtons.append(button)
        }
        ynCategoryButtons.removeAll()
        return formerHeight + 25
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = (scrollView.contentOffset.y + zjCycleViewH + zjNavigationBarHeight + zjStatusHeight)/150
        if offset > 1 {
            offset = 1
            let color = UIColor.orange.withAlphaComponent(offset)
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.backgroundColor = color
            UIApplication.shared.statusBarView?.backgroundColor = color
        } else {
            let color = UIColor.orange.withAlphaComponent(offset)
            self.navigationController?.navigationBar.tintColor = UIColor.orange.withAlphaComponent(1-offset)
            self.navigationController?.navigationBar.backgroundColor = color
            UIApplication.shared.statusBarView?.backgroundColor = color
        }
    }
}
