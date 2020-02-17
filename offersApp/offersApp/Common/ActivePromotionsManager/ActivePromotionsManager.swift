//
//  ActivePromotionsManager.swift
//  offersApp
//
//  Created by Роман Плахов on 15.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation

protocol ActivePromotionsManager {
	func isPromotionActive(promotionId: Int) -> Bool
	
	func activatePromotion(promotionId: Int)
	
	func deactivatePromotion(promotionId: Int)
}
