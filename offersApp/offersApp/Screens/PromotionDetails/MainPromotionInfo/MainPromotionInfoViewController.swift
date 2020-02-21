//
//  MainPromotionInfoViewController.swift
//  offersApp
//
//  Created by Роман Плахов on 13.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class MainPromotionInfoViewController: UIViewController {
	
	//MARK: Public properties
	var viewModel: MainPromotionInfoViewModel!
	weak var delegate: MainPromotionInfoViewControllerDelegate?
	
	//MARK: Private properties
	@IBOutlet private weak var remainingLabel: UILabel!
	@IBOutlet private weak var datesLabel: UILabel!
	@IBOutlet private weak var subtitleLabel: UILabel!
	@IBOutlet private weak var barcodeImageView: UIImageView!
	
	@IBOutlet private weak var scrollView: UIScrollView!
	
	//MARK: Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()

		setup()
		bind()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		delegate?.resetIsNeeded()
	}
	
	//MARK: Setup
	private func setup() {
		remainingLabel.textColor = Config.Colors.destructiveColor
		datesLabel.textColor = Config.Colors.paleTextColor
		subtitleLabel.textColor = Config.Colors.primaryTextColor
		
		remainingLabel.font = Config.Fonts.boldFont
		datesLabel.font = Config.Fonts.smallTextFont
		subtitleLabel.font = Config.Fonts.regularTextFont
	}
	
	//MARK: Binding
	private func bind() {
		remainingLabel.reactive.isHidden <~ viewModel.remainingTimerAvailable.map {!$0}
		remainingLabel.reactive.text <~ viewModel.remainingTime
		datesLabel.reactive.text <~ viewModel.dates
		subtitleLabel.reactive.text <~ viewModel.subtitle
		barcodeImageView.reactive.image <~ viewModel.barcode
	}

}

//MARK: IndicatorInfoProvider
extension MainPromotionInfoViewController: IndicatorInfoProvider {
	func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
		return IndicatorInfo(title: "Акция")
	}
}

protocol MainPromotionInfoViewControllerDelegate: class {
	func resetIsNeeded()
}
