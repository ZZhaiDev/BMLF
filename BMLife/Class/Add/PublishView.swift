//
//  PublishView.swift
//  百思不得姐-Swift
//
//  Created by Weili on 2016/11/9.
//  Copyright © 2016年 OuerTech. All rights reserved.
//

import UIKit
import pop

class PublishView: UIView {
    var sloganView:UIImageView!
    var publishWindow:UIWindow!
    lazy var imagesArr:Array! = { () -> [String] in
        let array = ["publish-video","publish-picture","publish-text","publish-audio","publish-review"]
        return array
    }()

    lazy var titlesArr:Array! = { () -> [String] in
        let array = ["City Activities","House Renting","School Activities", "Eat, drink, have fun", "Immigration"]
        return array
    }()

    @IBAction func buttonClick(_ sender: UIButton) {
        cancelWithCompletionBlock {
        }
    }

    func show() {
        publishWindow = UIWindow()
        publishWindow.frame = UIScreen.main.bounds
        publishWindow.backgroundColor = UIColor.init(white: 1.0, alpha: 1.0)
        publishWindow.isHidden = false
        self.frame = publishWindow.bounds
        publishWindow.addSubview(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = false
        setupButtons()
    }

    func setupButtons() {
        let maxCols = 3
        let buttonW = 72
        let buttonH = buttonW + 30
        let buttonStartX = 15
        let buttonMargx = (zjScreenWidth - CGFloat(maxCols * buttonW) - 2 * CGFloat(buttonStartX)) / CGFloat(maxCols - 1)
        let buttonStartY = (zjScreenHeight - 2 * CGFloat(buttonH)) / CGFloat(2)
        for  index in 0 ..< imagesArr.count {
            let button = VerticalButton(type: .custom)
            button.isHidden = true
            if index == 1 {
                button.isHidden = false
            }
            let row = index / maxCols
            let col = index % maxCols
            let buttonX = CGFloat(buttonStartX) + (buttonMargx + CGFloat(buttonW)) * CGFloat(col)

            let buttonEndY = buttonStartY + CGFloat(row) * CGFloat(buttonH)
            button.setImage(UIImage(named:imagesArr[index]), for: .normal)
            button.setTitle(titlesArr[index], for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            addSubview(button)
            button.addTarget(self, action: #selector(PublishView.clickButton(button:)), for: .touchUpInside)

            button.tag = index
            let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
            animation?.fromValue = NSValue.init(cgRect: CGRect(x: buttonX, y: CGFloat(buttonH) - zjScreenHeight, width: CGFloat(buttonW), height: CGFloat(buttonH)))
            animation?.toValue = NSValue.init(cgRect: CGRect(x: buttonX, y: CGFloat(buttonEndY), width: CGFloat(buttonW), height: CGFloat(buttonH)))
            animation?.springBounciness = 5
            animation?.springSpeed = 15
            animation?.beginTime = CACurrentMediaTime() + CFTimeInterval(0.1 * CGFloat(index))
            button.pop_add(animation, forKey: nil)
        }

        sloganView = UIImageView(image: UIImage(named: "app_slogan"))
        addSubview(sloganView)
        let centerX:CGFloat = zjScreenWidth * 0.5
        let centerEndY:CGFloat = zjScreenHeight * 0.2
        let centerBeginY:CGFloat = centerEndY - zjScreenHeight
        let animation = POPSpringAnimation(propertyNamed: kPOPViewCenter)
        animation?.fromValue = NSValue.init(cgPoint: CGPoint(x: centerX, y: centerBeginY))
        animation?.toValue = NSValue.init(cgPoint: CGPoint(x: centerX, y: centerEndY))
        animation?.springBounciness = 5
        animation?.springSpeed = 15
        animation?.beginTime = CACurrentMediaTime() + CFTimeInterval(0.1 * CGFloat(imagesArr.count))
        animation?.completionBlock = { (animation,finished) in
            self.isUserInteractionEnabled = true
        }
        sloganView.pop_add(animation, forKey: nil)
    }

    @objc func clickButton(button:VerticalButton) {
        if button.tag == 1 {
            cancelWithCompletionBlock {
                if let tvc = UIApplication.topViewController() {
                    let vc = ZJAddAptViewController()
                    let nvc = ZJNavigationController(rootViewController: vc)
                    tvc.present(nvc, animated: true, completion: nil)
                }
            }
        }
    }

    func cancelWithCompletionBlock(complentionBlock: @escaping () -> Void) {
        isUserInteractionEnabled = false
        for index in 1 ..< subviews.count {
            let subview = subviews[index]
            let animation = POPSpringAnimation(propertyNamed: kPOPViewCenter)
            let centerY:CGFloat = subview.center.y + zjScreenHeight
            animation?.springBounciness = 5
            animation?.springSpeed = 15
            animation?.toValue = NSValue.init(cgPoint: CGPoint(x: subview.center.x, y: centerY))
            animation?.beginTime = CACurrentMediaTime() + CFTimeInterval(CGFloat(index - 2) * 0.1)
            subview.pop_add(animation, forKey: nil)
            if index == subviews.count - 1 {
                animation?.completionBlock = {(animation,finished) in
                    self.removeFromSuperview()
                    self.publishWindow.isHidden = true
                    self.publishWindow = nil
                }
            }
        }
        complentionBlock()
    }
}
