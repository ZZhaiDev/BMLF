//
//  ZJRentAptListDetailRequirementCell.swift
//  BMLF
//
//  Created by zijia on 5/21/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit

class ZJRentAptListDetailRequirementCell: UICollectionViewCell {

    var titleButtons: [UIButton] = [UIButton]()
    var ynCategoryButtons = [YNCategoryButton]()
    var ynCategoryButtonType: YNCategoryButtonType = .border
    
    var titles = [String]() {
        didSet {
            ZJPrint(titles)
            setupUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        for button in ynCategoryButtons {
            button.removeFromSuperview()
        }
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
            button.setType(type: ynCategoryButtonType)
            button.setTitle(titles[index], for: .normal)
            button.tag = index
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
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
        case .ended:
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
