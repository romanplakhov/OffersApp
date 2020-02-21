//
//  PromotionDetailsViewController.swift
//  offersApp
//
//  Created by Роман Плахов on 11.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Kingfisher
import NVActivityIndicatorView

class PromotionDetailsViewController: UIViewController {

	//MARK: Public properties
	var viewModel: PromotionDetailsViewModel!
	var promotionDetailsPagerTabStrip: PromotionDetailsPagerTabStrip!
	
	//MARK: Private properties
	private var minCarouselHeight: CGFloat!
	private var maxCarouselHeight: CGFloat!
	
	@IBOutlet private weak var carouselView: UIImageView!
	@IBOutlet private weak var containerView: UIView!
	@IBOutlet private weak var actionView: UIView!
	
	@IBOutlet private weak var actionButton: ActionButton!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var offertTypeBadge: BadgeView!
	@IBOutlet private weak var discountRibbon: DiscountRibbon!
	@IBOutlet private weak var activityIndicator: NVActivityIndicatorView!
	
	@IBOutlet private weak var carouselHeightConstraint: NSLayoutConstraint!
	
	private var previousScrollOffset: CGFloat = 0
	private var panPreviousLocationY: CGFloat = 0
	
	private var storedBrightness: CGFloat?

	//MARK: Lyfecycle
	override func viewDidLoad() {
        super.viewDidLoad()

		setup()
		bind()
		
		maxCarouselHeight = UIScreen.main.bounds.height * 0.33
		minCarouselHeight = maxCarouselHeight / 2
		carouselHeightConstraint.constant = maxCarouselHeight
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		setupNavigationBar()
		storedBrightness = UIScreen.main.brightness
		UIScreen.main.setBrightness(to: storedBrightness! * 1.8, duration: 0.5)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if let brightness = storedBrightness {
			UIScreen.main.setBrightness(to: brightness, duration: 0.5)
		}
	}
	
	//MARK: Setup
	private func setup() {
		self.addChild(promotionDetailsPagerTabStrip)
		self.containerView.addSubview(promotionDetailsPagerTabStrip.view)
		
		promotionDetailsPagerTabStrip.didMove(toParent: self)
		promotionDetailsPagerTabStrip.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		promotionDetailsPagerTabStrip.view.frame = containerView.bounds
		
		setupActionButton()
		
		discountRibbon.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/4))
		offertTypeBadge.type = .offerTypeDetails
		
		titleLabel.font = Config.Fonts.detailsTitleFont
		
		activityIndicator.color = Config.Colors.primaryTintColor
		activityIndicator.type = .ballPulse
		
		carouselView.clipsToBounds = true
	}
	
	
	private func setupActionButton() {
		actionButton.configure(title: viewModel.promotionActivated ? "Деактивировать" : "Активировать", type: viewModel.promotionActivated ? .destructive : .constructive) {[weak self] in
			self?.viewModel.switchActivationStatus()
		}
	}
	
	private func setupNavigationBar() {
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.backgroundColor = .clear
		self.navigationController?.navigationBar.isTranslucent = true
		view.backgroundColor = .clear

	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	//MARK: Binding
	private func bind() {
		titleLabel.reactive.text <~ viewModel.title
		offertTypeBadge.reactive.text <~ viewModel.offerType
		discountRibbon.reactive.discountText <~ viewModel.discount
		viewModel.image.producer.observe(on: UIScheduler()).on {[weak self] urlString in
			guard let self = self,
				let url = URL(string: urlString) else {return}
			
			self.activityIndicator.startAnimating()
			self.carouselView.kf.setImage(with: url) { [weak self]_ in
				self?.carouselView.image = self?.carouselView.image?.darkened()
				self?.activityIndicator.stopAnimating()
			}
		}.start()
		
		viewModel.promotionActivationChangedSignal.producer.observe(on: UIScheduler()).on { [weak self] in
			self?.setupActionButton()
		}.start()
	}
}

//MARK: UITextViewDelegate
extension PromotionDetailsViewController: UITextViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let delta =  scrollView.contentOffset.y - previousScrollOffset
		
		if previousScrollOffset == 0 && delta>maxCarouselHeight {
			scrollView.contentOffset.y = 0
			return
		}

		if delta > 0 && carouselHeightConstraint.constant > minCarouselHeight && scrollView.contentOffset.y > 0 {
			carouselHeightConstraint.constant = max(carouselHeightConstraint.constant - delta, minCarouselHeight)
			scrollView.contentOffset.y -= delta
		}

		if delta < 0 && carouselHeightConstraint.constant < maxCarouselHeight && scrollView.contentOffset.y <= 0 {
			carouselHeightConstraint.constant = min(carouselHeightConstraint.constant - delta, maxCarouselHeight)
			scrollView.contentOffset.y -= delta
		}

		previousScrollOffset = scrollView.contentOffset.y
	}
}

extension PromotionDetailsViewController: MainPromotionInfoViewControllerDelegate {
	func resetIsNeeded() {
		carouselHeightConstraint.constant = maxCarouselHeight
	}
}
