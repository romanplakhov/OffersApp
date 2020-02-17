//
//  MainViewController.swift
//  offersApp
//
//  Created by Роман Плахов on 10.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class MainViewController: UINavigationController {
	var (lifetime, token) = Lifetime.make()
	
	var dependencyContainer: ViewControllersProvider!

	private func changeScreen(newScreenState: ScreenState) {
		let vc: UIViewController
		switch newScreenState {
		case .promotionDetails(let promotion):
			vc = dependencyContainer.makePromotionDetailsViewController(promotion: promotion)
		default:
			return
		}
		
		self.pushViewController(vc, animated: true)
	}
	
	override var childForStatusBarStyle: UIViewController? {
		return topViewController
	}
}

extension MainViewController: RedirectSignalsReceiver {
	var redirectSignalObserver: Signal<ScreenState, NoError>.Observer {
		return Signal<ScreenState, NoError>.Observer(
		value: {[weak self]state in
			guard let self = self else {return}
			self.changeScreen(newScreenState: state)
		})
	}
	
}
