//
//  ZJAddAptFooterView.swift
//  BMLF
//
//  Created by zijia on 5/18/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import YPImagePicker
import AVFoundation
import AVKit
import Photos

class ZJAddAptFooterView: UIView {
    
    var selectedItems = [YPMediaItem]()
    let selectedImageV = UIImageView()
    fileprivate lazy var imageBackGroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var resultsButton: UIButton = {
       let b = UIButton()
        b.setTitle("show images", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.addTarget(self, action: #selector(showResults), for: .touchUpInside)
        return b
    }()
    
    let pickButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")!.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(pickButton)
        pickButton.anchor(top: self.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
//        selectedImageV.contentMode = .scaleAspectFit
//        self.addSubview(selectedImageV)
//        selectedImageV.anchor(top: pickButton.bottomAnchor, left: pickButton.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        
        //第二个20位图片padding 5*4
        let height = (zjScreenWidth-20-20)/5 * (zjScreenHeight/zjScreenWidth)
        self.addSubview(imageBackGroundView)
        imageBackGroundView.anchor(top: pickButton.bottomAnchor, left: pickButton.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: height)
        
        self.addSubview(resultsButton)
        resultsButton.anchor(top: nil, left: pickButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 200, height: 30)
        resultsButton.centerYAnchor.constraint(equalTo: pickButton.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ZJAddAptFooterView{
    @objc fileprivate func handlePlusPhoto() {
        
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photoAndVideo
        config.shouldSaveNewPicturesToAlbum = false
        config.video.compression = AVAssetExportPresetMediumQuality
        config.startOnScreen = .library
        config.screens = [.library, .photo, .video]
        config.video.libraryTimeLimit = 500.0
//        config.showsCrop = .rectangle(ratio: (16/9))
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        
        config.library.maxNumberOfItems = 5
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }
            
            self.selectedItems = items
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
//                    self.selectedImageV.image = photo.image
                    self.setupImages(images: self.selectedItems)
                    picker.dismiss(animated: true, completion: nil)
                case .video(let video):
                    self.selectedImageV.image = video.thumbnail
                    
                    let assetURL = video.url
                    let playerVC = AVPlayerViewController()
                    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
                    playerVC.player = player
                    
                    picker.dismiss(animated: true, completion: { [weak self] in
                        if let vc = UIApplication.topViewController(){
                            vc.present(picker, animated: true, completion: nil)
                        }
                        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
                    })
                }
            }
        }
        if let vc = UIApplication.topViewController(){
            vc.present(picker, animated: true, completion: nil)
        }
        
    }
    
    func setupImages(images: [YPMediaItem]){
        let padding: CGFloat = 5
        let w: CGFloat = (self.imageBackGroundView.frame.size.width - 4*padding)/5
//        let count = images.count
        for (index, image) in images.enumerated(){
            switch image{
            case .photo(p: let photo):
                let imageV = UIImageView(frame: CGRect(x: CGFloat(index)*(w+padding), y: 0, width: w, height: self.imageBackGroundView.frame.size.height))
                imageV.image = photo.image
                imageBackGroundView.addSubview(imageV)
            case .video(let video): break
            }
        }
    }
    
    func resolutionForLocalVideo(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
    
    @objc
    func showResults() {
        if selectedItems.count > 0 {
            let gallery = YPSelectionsGalleryVC(items: selectedItems) { g, _ in
                g.dismiss(animated: true, completion: nil)
            }
            let navC = UINavigationController(rootViewController: gallery)
            if let vc = UIApplication.topViewController(){
                vc.present(navC, animated: true, completion: nil)
            }
            
        } else {
            print("No items selected yet.")
        }
    }
}
