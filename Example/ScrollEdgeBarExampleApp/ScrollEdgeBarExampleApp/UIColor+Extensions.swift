//
//  UIColor+Extensions.swift
//  ScrollEdgeBarExampleApp
//
//  Created by Jens Van Steen on 01/02/2026.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        guard hexString.count == 6,
              let value = UInt64(hexString, radix: 16) else {
            self.init(white: 0.0, alpha: alpha)
            return
        }

        let r = CGFloat((value & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((value & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(value & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
