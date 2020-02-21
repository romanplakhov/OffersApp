//
//  PromotionsListTableViewCell.swift
//  offersApp
//
//  Created by Роман Плахов on 10.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import UIKit
import Kingfisher
import SwipeCellKit
import M13Checkbox

class PromotionsListTableViewCell: SwipeTableViewCell {
	static let identifier = "PromotionsListTableViewCell"
	
	func configureCell(with promotion: MDPersonalPromotion) {
		if let promotionImageDescriptor = promotion.image,
			let thumbnailImageUrl = URL(string: promotionImageDescriptor.thumbnail) {
			thumbnailImageView.kf.setImage(with: thumbnailImageUrl)
		}
		
		titleLabel.text = promotion.title
		endDateLabel.text = promotion.validityEndDate != nil ? DataTransformHelper.formattedEndTime(endDate: promotion.validityEndDate!) : ""
		discountBadgeView.configure(with: promotion, type: .discount)
		offerTypeBadgeView.configure(with: promotion, type: .offerTypeIcon)
	}
	
	func setMultiselected(_ selected: Bool) {
		isMultiselected = selected
		
		if selected {
			self.contentView.backgroundColor = Config.Colors.cellSelectionColor
		} else {
			self.contentView.backgroundColor = .white
		}
		
		checkbox.setCheckState(selected ? .checked : .unchecked, animated: true)
	}
	
	func setMultiselectableMode(_ mode: Bool) {
		isMultiselectableMode = mode
		
		checkboxLeadingConstraint.constant = isMultiselectableMode ? shownCheckBoxLeadingConstraintConstant : hiddenCheckBoxLeadingConstraintConstant	}
	
	private(set) var isMultiselected = false
	private(set) var isMultiselectableMode = false
	
	private let hiddenCheckBoxLeadingConstraintConstant: CGFloat = -25
	private let shownCheckBoxLeadingConstraintConstant: CGFloat = 17
	
	
	
	@IBOutlet private weak var thumbnailImageView: UIImageView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var endDateLabel: UILabel!
	@IBOutlet private weak var discountBadgeView: BadgeView!
	@IBOutlet private weak var offerTypeBadgeView: BadgeView!
	@IBOutlet private weak var delimeter: UIView!
	@IBOutlet weak var checkbox: M13Checkbox!
	
	@IBOutlet weak var checkboxLeadingConstraint: NSLayoutConstraint!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
       
		setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
	}
	
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		guard !isMultiselected else {return}
		UIView.animate(withDuration: 0.3) { [unowned self] in
			if highlighted {
				self.contentView.backgroundColor = Config.Colors.cellSelectionColor
			} else {
				self.contentView.backgroundColor = .white
			}
		}
	}
	
	private func setup() {
		thumbnailImageView.layer.cornerRadius = 20
		thumbnailImageView.layer.masksToBounds = true
		delimeter.backgroundColor = Config.Colors.neutralColor
		delimeter.alpha = 0.5
		checkboxLeadingConstraint.constant = hiddenCheckBoxLeadingConstraintConstant
		checkbox.tintColor = Config.Colors.primaryTintColor
	}
    
}
