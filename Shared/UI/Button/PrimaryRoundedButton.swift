//
//  PrimaryRoundedButton.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class PrimaryRoundedButton: BaseButton {

	private var gradientLayer: CAGradientLayer? {
		didSet {
			guard let gradientLayer = gradientLayer
				else {
					return
			}
			if let oldValue = oldValue {
				oldValue.removeFromSuperlayer()
			}
			gradientLayer.cornerRadius = layer.cornerRadius
			layer.insertSublayer(gradientLayer, at: 0)
		}
	}

	let normalGradientColors = [Theme.Color.accentGradientStart, Theme.Color.accentGradientEnd]
	let selectedGradientColors = [Theme.Color.accentGradientStart.darkened, Theme.Color.accentGradientEnd.darkened]
	let highlightedGradientColors = [Theme.Color.accentGradientStart.darkened, Theme.Color.accentGradientEnd.darkened]
	let disabledGradientColors = [Theme.Color.accentGradientStart.lightened, Theme.Color.accentGradientEnd.lightened]

	override var cornerRadius: CGFloat {
		return 0.5 * bounds.size.height
	}

	override var titleFont: UIFont? {
		return Theme.Font.smallButtonFont
	}

	override var normalContentColor: UIColor? {
		return Theme.Color.largeButtonContent
	}

	override var selectedContentColor: UIColor? {
		return normalContentColor
	}

	override var highlightedContentColor: UIColor? {
		return normalContentColor
	}

	override var disabledContentColor: UIColor? {
		return normalContentColor
	}

	override var customContentEdgeInsets: UIEdgeInsets {
		if image(for: .normal) != nil {
			return UIEdgeInsets(top: 16.0, left: 25.0, bottom: 16.0, right: 25.0)
		}
		return UIEdgeInsets(top: 16.0, left: 22.0, bottom: 16.0, right: 22.0)
	}

	override var customImageEdgeInsets: UIEdgeInsets {
		if image(for: .normal) != nil {
			return UIEdgeInsets(top: 0.0, left: -3.0, bottom: 0.0, right: 3.0)
		}
		return UIEdgeInsets.zero
	}

	override var customTitleEdgeInsets: UIEdgeInsets {
		if image(for: .normal) != nil {
			return UIEdgeInsets(top: 0.0, left: 3.0, bottom: 0.0, right: -3.0)
		}
		return UIEdgeInsets.zero
	}

	func updateAppearance() {
		layer.cornerRadius = cornerRadius

		if isEnabled {
			if isHighlighted {
				gradientLayer = gradientLayer(with: highlightedGradientColors)
				setTitleColor(highlightedContentColor, for: state)
			}
			else if isSelected {
				gradientLayer = gradientLayer(with: selectedGradientColors)
				setTitleColor(selectedContentColor, for: state)
			}
			else {
				gradientLayer = gradientLayer(with: normalGradientColors)
				setTitleColor(normalContentColor, for: state)
			}
		}
		else {
			gradientLayer = gradientLayer(with: disabledGradientColors)
			setTitleColor(disabledContentColor, for: state)
		}
	}

	public override func layoutSubviews() {
		super.layoutSubviews()

		updateAppearance()
	}

	override func customize(title: String?) -> String? {
		return title?.uppercased()
	}

	private func gradientLayer(with colors: [UIColor]) -> CAGradientLayer {
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = bounds
		gradientLayer.colors = colors.map { $0.cgColor }
		gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
		gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.2)
		return gradientLayer
	}

}
