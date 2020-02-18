//
//  PromotionDetailsViewModel.swift
//  offersApp
//
//  Created by Роман Плахов on 11.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class PromotionDetailsViewModel {
	
	//MARK: Public members
	var promotionActivated: Bool {
		didSet {
			promotionActivationChangedSignalObserver.send(value: ())
		}
	}
	
	func switchActivationStatus() {
		if promotionActivated {
			activePromotionsManager.deactivatePromotion(promotionId: promotion.promoId)
		} else {
			activePromotionsManager.activatePromotion(promotionId: promotion.promoId)
		}
		
		promotionActivated = !promotionActivated
	}
	
	//MARK: Binding sources
	var promotionActivationChangedSignal: Signal<(), NoError>
	private var promotionActivationChangedSignalObserver: Signal<(), NoError>.Observer
	
	var title = MutableProperty<String>("")
	var discount = MutableProperty<String>("")
	var offerType = MutableProperty<String>("")
	var image = MutableProperty<String>("")
	
	//MARK: Private properties
	private var promotion: MDPersonalPromotion
	private var activePromotionsManager: ActivePromotionsManager
	
	init(promotion: MDPersonalPromotion,
		 activePromotionsManager: ActivePromotionsManager) {
		self.promotion = promotion
		self.activePromotionsManager = activePromotionsManager
		
		title.value = promotion.title
		discount.value = promotion.discount
		offerType.value = promotion.offerType.uppercased()
		image.value = promotion.image?.fullSize ?? ""
		
		promotionActivated = activePromotionsManager.isPromotionActive(promotionId: promotion.promoId)
		
		(promotionActivationChangedSignal, promotionActivationChangedSignalObserver) = Signal.pipe()
	}
	
}
