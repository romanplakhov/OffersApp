//
//  MainPromotionInfoViewModel.swift
//  offersApp
//
//  Created by Роман Плахов on 13.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation
import ReactiveSwift
import UIKit

class MainPromotionInfoViewModel {
	let remainingTimerAvailable = MutableProperty<Bool>(false)
	let remainingTime = MutableProperty<String>("")
	let dates = MutableProperty<String>("")
	let subtitle = MutableProperty<String>("")
	let barcode = MutableProperty<UIImage?>(nil)
	

	init(promotion: MDPersonalPromotion) {
		remainingTimerAvailable.value = promotion.showExpirationTimer
		remainingTime.value = promotion.validityEndDate != nil ? DataTransformHelper.timeRemaining(from: promotion.validityEndDate!) : ""
		dates.value = promotion.validityStartDate != nil && promotion.validityEndDate != nil ? DataTransformHelper.formattedTimeInterval(beginDate: promotion.validityStartDate!, endDate: promotion.validityEndDate!) : ""
		subtitle.value = promotion.subtitle
		barcode.value = DataTransformHelper.generateBarcode(from: promotion.barcode, type: promotion.barcodeType)
	}
	
}
