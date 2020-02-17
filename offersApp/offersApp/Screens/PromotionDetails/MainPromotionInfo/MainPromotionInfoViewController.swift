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
	
	var viewModel: MainPromotionInfoViewModel!
	
	@IBOutlet weak var remainingLabel: UILabel!
	@IBOutlet weak var datesLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var barcodeImageView: UIImageView!
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		setup()
		bind()
    }
	
	private func setup() {
		remainingLabel.textColor = Config.Colors.destructiveColor
		datesLabel.textColor = Config.Colors.paleTextColor
		subtitleLabel.textColor = Config.Colors.primaryTextColor
		
		remainingLabel.font = Config.boldFont
		datesLabel.font = Config.smallTextFont
		subtitleLabel.font = Config.regularTextFont
	}
	
	private func bind() {
		remainingLabel.reactive.isHidden <~ viewModel.remainingTimerAvailable.map {!$0}
		remainingLabel.reactive.text <~ viewModel.remainingTime
		datesLabel.reactive.text <~ viewModel.dates
		subtitleLabel.reactive.text <~ viewModel.subtitle
		barcodeImageView.reactive.image <~ viewModel.barcode
	}

}

extension MainPromotionInfoViewController: IndicatorInfoProvider {
	func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
		return IndicatorInfo(title: "Акция")
	}
}
