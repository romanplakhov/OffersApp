//
//  DiscountRibbon.swift
//  offersApp
//
//  Created by Роман Плахов on 16.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

extension Reactive where Base: DiscountRibbon {
	 var discountText: BindingTarget<String?> {
		return makeBindingTarget { $0.discountLabel.text = $1 }
    }
}

class DiscountRibbon: UIView {
	@IBOutlet var view: UIView!
	@IBOutlet weak var discountLabel: UILabel!
	
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DiscountRibbon", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		discountLabel.backgroundColor = Config.Colors.primaryTintColor
		discountLabel.textColor = Config.Colors.alternativeTextColor
		discountLabel.font = Config.discountRibbonFont
		discountLabel.adjustsFontSizeToFitWidth = true
		self.backgroundColor = .clear
    }
}
