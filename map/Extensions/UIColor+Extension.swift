//
//  UIColor+Extension.swift
//  map
//
//  Created by 코드잉 on 2021/03/10.
//

import UIKit

extension UIColor {
    class var publicTransitTableViewCellBorderColor: UIColor {
        UIColor("#efefef")
    }

    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var rgbValue = hex
        if rgbValue.hasPrefix("#") {
            rgbValue.removeFirst()
        }
        var rgb: UInt64 = 0
        Scanner(string: rgbValue).scanHexInt64(&rgb)
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgb & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
