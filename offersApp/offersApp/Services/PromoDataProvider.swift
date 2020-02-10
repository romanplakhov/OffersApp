//
//  PromoDataProvider.swift
//  offersApp
//
//  Created by Роман Плахов on 10.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation

enum PromoDataLoadingError: Error {
	case unknownError
	case loadingError
}

protocol PromoDataProvider {
	func getPromoData(completion: @escaping ([MDPersonalPromotion])->(), failure: @escaping (PromoDataLoadingError)->())
}
