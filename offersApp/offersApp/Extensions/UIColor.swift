//
//  UIColor+hex.swift
//  offersApp
//
//  Created by Роман Плахов on 12.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import UIKit

extension UIColor {
	static func linearGradientColor(from colors: [UIColor], locations: [CGFloat], size: CGSize) -> UIColor {
		let image = UIGraphicsImageRenderer(bounds: CGRect(x: 0, y: 0, width: size.width, height: size.height)).image { context in
			let cgColors = colors.map { $0.cgColor } as CFArray
			let colorSpace = CGColorSpaceCreateDeviceRGB()
			let gradient = CGGradient(
				colorsSpace: colorSpace,
				colors: cgColors,
				locations: locations
			)!
			context.cgContext.drawLinearGradient(
				gradient,
				start: CGPoint(x: 0, y: 0),
				end: CGPoint(x: size.width, y:0),
				options:[]
			)
		}
		return UIColor(patternImage: image)
	}
	
	convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
