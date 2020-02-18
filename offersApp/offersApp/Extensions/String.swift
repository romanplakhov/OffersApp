//
//  String.swift
//  offersApp
//
//  Created by Роман Плахов on 13.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation

extension String {
	var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
			let attributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
			attributedString.addAttribute(.font, value: Config.Fonts.regularTextFont, range: NSMakeRange(0, attributedString.length))
			return attributedString
        } catch {
            return NSAttributedString()
        }
    }
}
