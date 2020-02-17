//
//  PromotionDescriptionViewController.swift
//  offersApp
//
//  Created by Роман Плахов on 13.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class PromotionDescriptionViewController: UIViewController {

	var viewModel: PromotionDescriptionViewModel!
	var scrollingDelegate: UITextViewDelegate!
	@IBOutlet weak var descriptionContentView: UITextView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		descriptionContentView.delegate = scrollingDelegate
		
		bind()

		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		descriptionContentView.setContentOffset(CGPoint(x: 0,y: 0), animated: false)
	}
	
	private func bind() {
		descriptionContentView.reactive.attributedText <~ viewModel.attributedDescription
	}


}


extension PromotionDescriptionViewController: IndicatorInfoProvider {
	func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
		return IndicatorInfo(title: "Ассортимент")
	}
}
