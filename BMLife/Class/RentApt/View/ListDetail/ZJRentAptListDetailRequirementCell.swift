//
//  ZJRentAptListDetailRequirementCell.swift
//  BMLF
//
//  Created by zijia on 5/21/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class ZJRentAptListDetailRequirementCell: UICollectionViewCell {
    
    
    
    open var ynCategoryButtons = [YNCategoryButton]()
    var ynCategoryButtonType: YNCategoryButtonType = .border
    var titles = [String](){
        didSet{
            setupUI1()
        }
    }
    var titleButtons: [UIButton] = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    func setupUI1(){
        let margin: CGFloat = 15
        var formerWidth: CGFloat = 15
        var formerHeight: CGFloat = 0
        
        
        let font = UIFont.systemFont(ofSize: 12)
        let userAttributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor: UIColor.gray]
        for i in 0..<titles.count {
            let size = titles[i].size(withAttributes: userAttributes)
            if i > 0 {
                formerWidth = ynCategoryButtons[i-1].frame.size.width + ynCategoryButtons[i-1].frame.origin.x + 10
                if formerWidth + size.width + margin > UIScreen.main.bounds.width {
                    formerHeight += ynCategoryButtons[i-1].frame.size.height + 10
                    formerWidth = margin
                }
            }
            let button = YNCategoryButton(frame: CGRect(x: formerWidth, y: formerHeight, width: size.width + 10, height: size.height + 10))
            button.setType(type: ynCategoryButtonType)
//        button.addTarget(self, action: #selector(ynCategoryButtonClicked(_:)), for: .touchUpInside)
            button.setTitle(titles[i], for: .normal)
            button.tag = i
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
            //            panGestureRecognizer.delegate = self
            button.addGestureRecognizer(panGestureRecognizer)
    
            ynCategoryButtons.append(button)
            self.addSubview(button)
    
        }
    }
    

    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        let gview = recognizer.view as! UIButton
        let translation = recognizer.translation(in: gview.superview)
        
        switch recognizer.state {
        case .began, .changed:
            gview.layer.transform = CATransform3DMakeTranslation(translation.x, translation.y, 0)
            // OR
        // imgView.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        case .ended:
//            if deleteButton.frame.intersects(gview.layer.frame) {
//                animateDelete(sender: gview)
//            } else {
//                moveBack(sender: gview)
//            }
            moveBack(sender: gview)
        default:
            moveBack(sender: gview)
        }
    }
    
    func moveBack(sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
        }
    }
        
        
}
