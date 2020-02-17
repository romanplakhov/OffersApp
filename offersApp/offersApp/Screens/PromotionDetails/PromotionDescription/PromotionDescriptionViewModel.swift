//
//  PromotionDescriptionViewModel.swift
//  offersApp
//
//  Created by Роман Плахов on 13.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation
import ReactiveSwift

class PromotionDescriptionViewModel {
	
	var attributedDescription = MutableProperty<NSAttributedString?>(nil)
	
	init(promotion: MDPersonalPromotion) {
		attributedDescription.value = promotion.promoDescription.htmlToAttributedString
	}
	
}
