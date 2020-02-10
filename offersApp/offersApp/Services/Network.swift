//
//  Network.swift
//  offersApp
//
//  Created by Роман Плахов on 10.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation

class Network: PromoDataProvider {
	func getPromoData(completion: @escaping ([MDPersonalPromotion]) -> (), failure: @escaping (PromoDataLoadingError) -> ()) {
		fatalError("Network layer has not been implemented! Use MockNetwork instead.")
	}
	
	
}
