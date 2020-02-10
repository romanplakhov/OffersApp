//
//  MDPersonalPromotion.swift
//  offersApp
//
//  Created by Роман Плахов on 10.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import Kingfisher
import ReactiveSwift
import UIKit

class MDPersonalPromotion: Object {
	class MDPromoImage: Object {
		
		static func from(_ json: JSON) -> MDPromoImage {
			return MDPromoImage(thumbnail: json["thumbnail"].stringValue,
								medium: json["medium"].stringValue,
								fullSize: json["fullSize"].stringValue,
								mediumLossy: json["mediumLossy"].stringValue)
		}
		
		
		@objc dynamic var thumbnail: String = ""
		@objc dynamic var medium: String = ""
		@objc dynamic var fullSize: String = ""
		@objc dynamic var mediumLossy: String = ""
		
		var thumbnailImage = MutableProperty<UIImage?>(nil)
		var mediumImage = MutableProperty<UIImage?>(nil)
		var fullSizelImage = MutableProperty<UIImage?>(nil)
		var mediumLossyImage = MutableProperty<UIImage?>(nil)
		
		convenience init(thumbnail: String,
						 medium: String,
						 fullSize: String,
						 mediumLossy: String) {
			self.init()
			
			self.thumbnail = thumbnail
			self.medium = medium
			self.fullSize = fullSize
			self.mediumLossy = mediumLossy
		}
	}
	
	static func from(_ json: JSON) -> MDPersonalPromotion {
		return MDPersonalPromotion(promoId: json["id"].intValue,
								   title: json["title"].stringValue,
								   promoDescription: json["description"].stringValue,
								   discount: json["discount"].stringValue,
								   image: MDPromoImage.from(json["image"]),
								   validityStartDate: json["validityStartDate"].stringValue,
								   validityEndDate: json["validityEndDate"].stringValue,
								   barcodeType: json["barcodeType"].stringValue,
								   barcode: json["barcode"].stringValue,
								   showExpirationTimer: json["showExpirationTime"].boolValue,
								   offerType: json["offerType"].stringValue)
	}
	
	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		let utcStringTemplate = "yyyy-MM-dd'T'HH:mm:ssZ"
		formatter.dateFormat = utcStringTemplate
		return formatter
	}()
	
	
	@objc dynamic var promoId: Int = 0
	@objc dynamic var title: String = ""
	@objc dynamic var promoDescription: String = ""
	@objc dynamic var discount: String = ""
	@objc dynamic var image: MDPromoImage? = nil
	@objc dynamic var validityStartDateUTC: String = ""
	@objc dynamic var validityEndDateUTC: String = ""
	@objc dynamic var barcodeType: String = ""
	@objc dynamic var barcode: String = ""
	@objc dynamic var showExpirationTimer: Bool = false
	@objc dynamic var offerType: String = ""
	
	var validityStartDate: Date? {
		return dateFormatter.date(from: validityStartDateUTC)
	}
	
	var validityEndDate: Date? {
		return dateFormatter.date(from: validityEndDateUTC)
	}
	
	convenience init(promoId: Int,
					 title: String,
					 promoDescription: String,
					 discount: String,
					 image: MDPromoImage?,
					 validityStartDate: String,
					 validityEndDate: String,
					 barcodeType: String,
					 barcode: String,
					 showExpirationTimer: Bool,
					 offerType: String) {
		self.init()
		
		self.promoId = promoId
		self.title = title
		self.promoDescription = promoDescription
		self.discount = discount
		self.image = image
		self.validityStartDateUTC = validityStartDate
		self.validityEndDateUTC = validityEndDate
		self.barcodeType = barcodeType
		self.barcode = barcode
		self.showExpirationTimer = showExpirationTimer
		self.offerType = offerType
	}
	
	
}


