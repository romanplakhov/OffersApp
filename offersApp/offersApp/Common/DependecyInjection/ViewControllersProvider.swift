//
//  DependencyProvider.swift
//  offersApp
//
//  Created by Роман Плахов on 17.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation

protocol ViewControllersProvider {
	var mainViewController: MainViewController {get}
	
	func makePromotionDetailsViewController(promotion: MDPersonalPromotion) -> PromotionDetailsViewController
}
