//
//  YNCategoryButton.swift
//  YNSearch
//
//  Created by Seungyoun Yi on 2017. 4. 12..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

public enum YNCategoryButtonType {
    case background
    case border
    case colorful
}

open class YNCategoryButton: UIButton {
    open var type: YNCategoryButtonType? {
        didSet {
            guard let tempType = type else { return }
            self.setType(type: tempType)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initVIew()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open var isHighlighted: Bool {
        didSet {
            if let type = self.type {
                switch type {
                case .border:
                    switch isHighlighted {
                    case true:
                        layer.borderColor = UIColor.lightGray.cgColor
                    case false:
                        layer.borderColor = UIColor.darkGray.cgColor
                    }

                case .colorful:
                    switch isHighlighted {
                    case true:
                        layer.borderColor = UIColor.lightGray.cgColor
                    case false:
                        layer.borderColor = UIColor.white.cgColor
                    }

                case .background: break
                }

            } else {
                switch isHighlighted {
                case true:
                    layer.borderColor = UIColor.lightGray.cgColor
                case false:
                    layer.borderColor = UIColor.darkGray.cgColor
                }
            }
        }
    }
    open func initVIew() {
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.setTitleColor(UIColor.darkGray, for: .normal)
        self.setTitleColor(UIColor.lightGray, for: .highlighted)
        self.layer.cornerRadius = self.frame.height * 0.1

    }

    open func setType(type: YNCategoryButtonType) {
        switch type {
        case .background:
            self.layer.borderColor = nil
            self.layer.borderWidth = 0
            self.backgroundColor = UIColor.init(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1)
            self.setTitleColor(UIColor.darkGray, for: .normal)
            self.setTitleColor(UIColor.darkGray.withAlphaComponent(0.3), for: .highlighted)

        case .border:
            self.layer.borderColor = UIColor.darkGray.cgColor
            self.layer.borderWidth = 1
            self.setTitleColor(UIColor.darkGray, for: .normal)
            self.setTitleColor(UIColor.darkGray.withAlphaComponent(0.3), for: .highlighted)

        case .colorful:
            self.layer.borderColor = nil
            self.layer.borderWidth = 0
//            self.backgroundColor = randomColor()
            self.backgroundColor = UIColor.red
            self.setTitleColor(UIColor.white, for: .normal)
            self.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        }

    }

    open func randomColor() -> UIColor {
        // swiftlint:disable ine_length
        let colorArray = ["009999", "0099cc", "0099ff", "00cc99", "00cccc", "336699", "3366cc", "3366ff", "339966", "666666", "666699", "6666cc", "6666ff", "996666", "996699", "999900", "999933", "99cc00", "99cc33", "660066", "669933", "990066", "cc9900", "cc6600" , "cc3300", "cc3366", "cc6666", "cc6699", "cc0066", "cc0033", "ffcc00", "ffcc33", "ff9900", "ff9933", "ff6600", "ff6633", "ff6666", "ff6699", "ff3366", "ff3333"]

        let randomNumber = arc4random_uniform(UInt32(colorArray.count))
        return UIColor(hexString: colorArray[Int(randomNumber)])
    }

}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        // swiftlint:disable identifier_name
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
