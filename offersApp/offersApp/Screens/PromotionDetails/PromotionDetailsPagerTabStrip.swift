//
//  PromotionDetailsPagerTabStrip.swift
//  offersApp
//
//  Created by Роман Плахов on 13.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import UIKit

class PromotionDetailsPagerTabStrip: ButtonBarPagerTabStripViewController {
	
	private var mainPromotionInfoViewController: MainPromotionInfoViewController
	private var promotionDescriptionViewController: PromotionDescriptionViewController
	
	
	
	init(mainPromotionInfoViewController: MainPromotionInfoViewController, promotionDescriptionViewController: PromotionDescriptionViewController) {
		
		self.mainPromotionInfoViewController = mainPromotionInfoViewController
		self.promotionDescriptionViewController = promotionDescriptionViewController
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		setupStyle()
		
		super.viewDidLoad()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	private func setupStyle() {
		self.settings.style.selectedBarBackgroundColor = Config.Colors.primaryTintColor
		self.settings.style.buttonBarBackgroundColor = Config.Colors.primaryBackgroundColor
		self.settings.style.buttonBarItemFont = Config.mainFont
		self.settings.style.buttonBarItemTitleColor = Config.Colors.secondaryTextColor
		self.settings.style.buttonBarSelectedItemTitleColor = Config.Colors.primaryTextColor
		self.settings.style.buttonBarItemBackgroundColor = Config.Colors.primaryBackgroundColor
		self.settings.style.selectedBarHeight = 2
		self.settings.style.selectedBarWidthMultiplier = 0.5
		

		self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
	}
	
	override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
		return [mainPromotionInfoViewController, promotionDescriptionViewController]
	}
}


