//
//  ScreenState.swift
//  offersApp
//
//  Created by Роман Плахов on 10.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

enum ScreenState {
	case segmentedPromotionsList
	case promotionDetails(promotion: MDPersonalPromotion)
	
	var title: String {
		switch self {
		case .segmentedPromotionsList:
			return "Предложения"
		case .promotionDetails:
			return ""
		}
	}
}
