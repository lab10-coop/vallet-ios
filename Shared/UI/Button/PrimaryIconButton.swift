//
//  PrimaryIconButton.swift
//  Vallet
//
//  Created by Matija Kregar on 04/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class PrimaryIconButton: PrimaryRoundedButton {

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

	var backgroundTransparency: CGFloat = 0.7

	override var normalGradientColors: [UIColor] {
		return [Theme.Color.accentGradientStart.transparent(alpha: backgroundTransparency), Theme.Color.accentGradientEnd.transparent(alpha: backgroundTransparency)]
	}
	override var selectedGradientColors: [UIColor] {
		return [Theme.Color.accentGradientStart.darkened.transparent(alpha: backgroundTransparency), Theme.Color.accentGradientEnd.darkened.transparent(alpha: backgroundTransparency)]
	}
	override var highlightedGradientColors: [UIColor] {
		return [Theme.Color.accentGradientStart.darkened.transparent(alpha: backgroundTransparency), Theme.Color.accentGradientEnd.darkened.transparent(alpha: backgroundTransparency)]
	}
	override var disabledGradientColors: [UIColor] {
		return [Theme.Color.accentGradientStart.lightened.transparent(alpha: backgroundTransparency), Theme.Color.accentGradientEnd.lightened.transparent(alpha: backgroundTransparency)]
	}

	override var customContentEdgeInsets: UIEdgeInsets {
		return UIEdgeInsets(top: 16.0, left: 0.0, bottom: 16.0, right: 0.0)
	}

	override var customImageEdgeInsets: UIEdgeInsets {
		return UIEdgeInsets.zero
	}

	override var customTitleEdgeInsets: UIEdgeInsets {
		return UIEdgeInsets.zero
	}

}
