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

	//MARK: Public properties
	var viewModel: PromotionDescriptionViewModel!
	var scrollingDelegate: UITextViewDelegate!
	
	//MARK: Private properties
	@IBOutlet private weak var descriptionContentView: UITextView!
	
	//MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		descriptionContentView.delegate = scrollingDelegate
		
		bind()
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		descriptionContentView.setContentOffset(CGPoint(x: 0,y: 0), animated: false)
	}
	
	//MARK: Binding
	private func bind() {
		descriptionContentView.reactive.attributedText <~ viewModel.attributedDescription
	}
}

//MARK: IndicatorInfoProvider
extension PromotionDescriptionViewController: IndicatorInfoProvider {
	func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
		return IndicatorInfo(title: "Ассортимент")
	}
}
