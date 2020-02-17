//
//  UserDefaultsActivePromotionsManager.swift
//  offersApp
//
//  Created by Роман Плахов on 17.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation

class UserDefaultsActivePromotionsManager: ActivePromotionsManager {
	public func isPromotionActive(promotionId: Int) -> Bool {
		return activePromotionsIdsList.contains(promotionId)
	}
	
	public func activatePromotion(promotionId: Int) {
		activePromotionsIdsList.update(with: promotionId)
	}
	
	public func deactivatePromotion(promotionId: Int) {
		activePromotionsIdsList.remove(promotionId)
	}
	
	
	private let userDefaultsKey = "activePromotionsIdsKey"
	
	private var activePromotionsIdsList: Set<Int> {
		get {
			guard let decoded  = UserDefaults.standard.object(forKey: userDefaultsKey) as? Data else {return Set<Int>()}
			return NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Set<Int> ?? Set<Int>()
		}
		set {
			let encodedData = NSKeyedArchiver.archivedData(withRootObject: newValue)
			UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
		}
	}
}
