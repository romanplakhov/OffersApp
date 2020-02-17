//
//  DependencyContainer.swift
//  offersApp
//
//  Created by Роман Плахов on 10.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation
import ReactiveSwift

class DependencyContainer: ViewControllersProvider {
	// Long-lived dependencies
	lazy var mainViewController: MainViewController = {
		let activatedPromotionsListViewController = makePromotionsListViewController(type: .active)
		let notActivatedPromotionsListViewController = makePromotionsListViewController(type: .inactive)
		let mainViewController = MainViewController(rootViewController: makePromotionsListPagerTabStrip(activePromotionsList: activatedPromotionsListViewController, inactivePromotionsList: notActivatedPromotionsListViewController))
		mainViewController.dependencyContainer = self
		
		activatedPromotionsListViewController.viewModel.redirectSignal.observe(mainViewController.redirectSignalObserver)
		notActivatedPromotionsListViewController.viewModel.redirectSignal.observe(mainViewController.redirectSignalObserver)
		
		return mainViewController
	}()

	lazy var activePromotionsManager: ActivePromotionsManager = {
		return UserDefaultsActivePromotionsManager()
	}()
	
	lazy var promotionsRepository: Repository<MDPersonalPromotion> = {
		return Repository(RealmRepository<MDPersonalPromotion>())
	}()
	
	func makePromotionsListPagerTabStrip(activePromotionsList: PromotionsListViewController, inactivePromotionsList: PromotionsListViewController) -> PromotionsListPagerTabStrip {
		let promotionsListPagerTabStrip = PromotionsListPagerTabStrip(activePromotionsList: activePromotionsList, inactivePromotionsList: inactivePromotionsList)
		
		return promotionsListPagerTabStrip
	}
	
	func makePromotionsListViewController(type: PromotionsListType) -> PromotionsListViewController {
		let promotionsListViewModel = PromotionsListViewModel(type: type, network: MockNetwork(),
															  repository: promotionsRepository,
															  activePromotionsManager: activePromotionsManager)
		let promotionsListViewController = PromotionsListViewController()
		promotionsListViewController.viewModel = promotionsListViewModel
		return promotionsListViewController
	}
	
	func makePromotionDetailsViewController(promotion: MDPersonalPromotion) -> PromotionDetailsViewController {
		let promotionDetailsViewModel = PromotionDetailsViewModel(promotion: promotion,
																  activePromotionsManager: activePromotionsManager)
		let promotionDetailsViewController = PromotionDetailsViewController()
		promotionDetailsViewController.viewModel = promotionDetailsViewModel
		let promotionDetailsPagerTabStrip =  makePromotionDetailsPagerTabStrip(promotion: promotion, scrollingDelegate: promotionDetailsViewController)
		promotionDetailsViewController.promotionDetailsPagerTabStrip = promotionDetailsPagerTabStrip

		
		return promotionDetailsViewController
	}
	
	func makeMainPromotionInfoViewController(promotion: MDPersonalPromotion) -> MainPromotionInfoViewController {
		let mainPromotionInfoViewModel = MainPromotionInfoViewModel(promotion: promotion)
		let mainPromorionInfoViewController = MainPromotionInfoViewController()
		mainPromorionInfoViewController.viewModel = mainPromotionInfoViewModel
		
		return  mainPromorionInfoViewController
	}
	
	func makePromotionDescriptionViewController(promotion: MDPersonalPromotion) -> PromotionDescriptionViewController {
		let promotionDescriptionViewModel = PromotionDescriptionViewModel(promotion: promotion)
		let promotionDescriptionViewController = PromotionDescriptionViewController()
		promotionDescriptionViewController.viewModel = promotionDescriptionViewModel
		
		return promotionDescriptionViewController
	}
	
	func makePromotionDetailsPagerTabStrip(promotion: MDPersonalPromotion, scrollingDelegate: UITextViewDelegate) -> PromotionDetailsPagerTabStrip {
		let mainPromotionInfoViewController = makeMainPromotionInfoViewController(promotion: promotion)
		
		let promotionDescriptionViewController = makePromotionDescriptionViewController(promotion: promotion)
		promotionDescriptionViewController.scrollingDelegate = scrollingDelegate
		
		return PromotionDetailsPagerTabStrip(mainPromotionInfoViewController: mainPromotionInfoViewController, promotionDescriptionViewController: promotionDescriptionViewController)
	}
}
