//
//  PromotionsListPagerTabStrip.swift
//  offersApp
//
//  Created by Роман Плахов on 12.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import UIKit

class PromotionsListPagerTabStrip: ButtonBarPagerTabStripViewController {
	private var activePromotionsList: PromotionsListViewController
	private var inactivePromotionsList: PromotionsListViewController
	
	
	
	init(activePromotionsList: PromotionsListViewController, inactivePromotionsList: PromotionsListViewController) {
		self.activePromotionsList = activePromotionsList
		self.inactivePromotionsList = inactivePromotionsList
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		setupStyle()
		
		super.viewDidLoad()

		setupSubstrateView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		setupNavigationBar()

		activePromotionsList.viewModel.updateData()
		inactivePromotionsList.viewModel.updateData()
	}
	
	private func setupNavigationBar() {
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.backgroundColor = .white
		self.navigationController?.navigationBar.isTranslucent = false
		self.navigationController?.navigationBar.backgroundColor = .clear
		self.navigationController?.navigationBar.tintColor = .white
		
		let label = UILabel()
		label.textColor = UIColor.black
		label.text = "Предложения"
		label.font = Config.headersFont
		label.sizeToFit()
		
		self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
		
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
	
	private func setupSubstrateView() {
		let substrateView = UIView(frame: CGRect(x: 0, y: -100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+100))
		substrateView.backgroundColor = .white
		view.insertSubview(substrateView, at: 0)
	}
	
	override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
		return [activePromotionsList, inactivePromotionsList]
	}
}
