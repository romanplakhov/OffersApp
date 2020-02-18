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
	}
	
	var isMultiselected = false
	
	
	@IBOutlet private weak var thumbnailImageView: UIImageView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var endDateLabel: UILabel!
	@IBOutlet private weak var discountBadgeView: BadgeView!
	@IBOutlet private weak var offerTypeBadgeView: BadgeView!
	@IBOutlet private weak var delimeter: UIView!
	
	
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
	}
    
}
