//
//  MockNetwork.swift
//  offersApp
//
//  Created by Роман Плахов on 10.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation
import SwiftyJSON
import Reachability

class MockNetwork: PromoDataProvider {
	func getPromoData(completion: @escaping ([MDPersonalPromotion]) -> (), failure: @escaping (PromoDataLoadingError) -> ()) {
		guard let url = Bundle.main.url(forResource: "MockPromoData", withExtension: ".json"),
			let data = try? Data(contentsOf: url),
			let json = try? JSON(data: data) else {
			failure(.loadingError)
			return
		}
		
		let promosJSONObject = json["personalPromotions"]
		
		var promotions: [MDPersonalPromotion] = []
		for object in promosJSONObject {
			promotions.append(MDPersonalPromotion.from(object.1))
		}
		
		completion(promotions)
	}
}
