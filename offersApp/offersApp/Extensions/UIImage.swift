//
//  UIImage.swift
//  offersApp
//
//  Created by Роман Плахов on 21.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import UIKit

extension UIImage {
	func darkened() -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		defer { UIGraphicsEndImageContext() }
		guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
			return nil
		}

		ctx.scaleBy(x: 1.0, y: -1.0)
		ctx.translateBy(x: 0, y: -size.height)
		let rect = CGRect(origin: .zero, size: size)
		ctx.draw(cgImage, in: rect)
		UIColor(white: 0, alpha: 0.3).setFill()
		ctx.fill(rect)
		return UIGraphicsGetImageFromCurrentImageContext()
	}
}
