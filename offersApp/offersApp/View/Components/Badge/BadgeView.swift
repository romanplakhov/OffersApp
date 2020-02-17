//
//  BadgeView.swift
//  offersApp
//
//  Created by Роман Плахов on 12.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import UIKit

enum BadgeViewType {
	case discount
	case offerTypeIcon
	case offerTypeDetails
	
	var horizontalInset: CGFloat {
		switch self {
		case .discount:
			return 13.0
		case .offerTypeIcon:
			return 10.0
		case .offerTypeDetails:
			return 10.0
		}
	}
	
	var verticalInset: CGFloat {
		switch self {
		case .discount:
			return 5.0
		case .offerTypeIcon:
			return 3.0
		case .offerTypeDetails:
			return 8.0
		}
	}
	
	var font: UIFont {
		switch self {
		case .discount:
			return Config.boldFont
		case .offerTypeIcon:
			return Config.offerTypeBadgeFont
		case .offerTypeDetails:
			return Config.offerTypeBadgeFont
		}
	}
}

class BadgeView: UILabel {
	public func configure(with promotion: MDPersonalPromotion, type: BadgeViewType) {
		self.type = type
		
		switch type {
		case .discount:
			self.text = promotion.discount
		case .offerTypeIcon, .offerTypeDetails:
			self.text = promotion.offerType.uppercased()
		}
	}
	
	var type: BadgeViewType = .discount {
		didSet {
			switch type {
			case .discount:
				self.backgroundColor = Config.Colors.primaryTintColor
			case .offerTypeIcon, .offerTypeDetails:
				self.backgroundColor = Config.Colors.secondaryTintColor
			}
			
			self.font = type.font
		}
	}
	
    override init(frame: CGRect) {
        super.init(frame: frame)
		commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		commonInit()
    }
    
    private func commonInit() {
        setup()
    }
	
    override func drawText(in rect: CGRect) {
		let insets = UIEdgeInsets.init(top: type.verticalInset, left: type.horizontalInset, bottom: type.verticalInset, right: type.horizontalInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
		let newSize = CGSize(width: size.width + type.horizontalInset * 2,
		height: size.height + type.verticalInset * 2)
		
		self.layer.cornerRadius = newSize.height/2
		self.layer.masksToBounds = true
		
        return newSize
    }
	
	private func setup() {
        adjustsFontSizeToFitWidth = true
		baselineAdjustment = .alignCenters
		
		self.textColor = Config.Colors.alternativeTextColor
		self.font = Config.boldFont
		
	}
}
