//
//  ActionButton.swift
//  offersApp
//
//  Created by Роман Плахов on 13.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation
import UIKit

enum ActionButtonType {
	case constructive
	case destructive
	case neutral
	
	var backgroundColor: UIColor {
		switch self {
		case .constructive:
			return Config.Colors.constructiveColor
		case .destructive:
			return Config.Colors.destructiveColor
		case .neutral:
			return Config.Colors.neutralColor
		}
	}
}

class ActionButton: UIButton {
	public func configure(title: String, type: ActionButtonType, action:  @escaping ()->()) {
		setTitle(title, for: .normal)
		backgroundColor = type.backgroundColor
		self.action = action
	}
	
	private var action: (()->())?
	
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
	
	private func setup() {
		self.setTitleColor(Config.Colors.alternativeTextColor, for: .normal)
		self.layer.cornerRadius = self.bounds.height/2
		self.titleLabel?.font = Config.Fonts.actionButtonFont
		self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
		self.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
		self.startAnimatingPressActions()
		
		self.layer.masksToBounds = true
	}
	
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
		let newSize = CGSize(width: size.width + 30,
		height: size.height + 10)
		
		self.layer.cornerRadius = newSize.height/2

		
        return newSize
    }
	
	
	
	@objc func onButtonTapped() {
		action?()
	}
}


extension ActionButton {
	func startAnimatingPressActions() {
		addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
		addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
	}
	
	@objc private func animateDown(sender: UIButton) {
		animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
	}
	
	@objc private func animateUp(sender: UIButton) {
		animate(sender, transform: .identity)
	}
	
	private func animate(_ button: UIButton, transform: CGAffineTransform) {
		UIView.animate(withDuration: 0.4,
					   delay: 0,
					   usingSpringWithDamping: 0.5,
					   initialSpringVelocity: 3,
					   options: [.curveEaseInOut],
					   animations: {
						button.transform = transform
		}, completion: nil)
	}
}

