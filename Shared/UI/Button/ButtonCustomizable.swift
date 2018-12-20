//
//  ButtonCustomizable.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

protocol ButtonCustomizable: AnyObject {

	var cornerRadius: CGFloat { get }

	var customContentEdgeInsets: UIEdgeInsets { get }
	var customTitleEdgeInsets: UIEdgeInsets { get }
	var customImageEdgeInsets: UIEdgeInsets { get }
	
	var titleFont: UIFont? { get }

	var normalContentColor: UIColor? { get }
	var normalBackgroundColor: UIColor? { get }

	var selectedContentColor: UIColor? { get }
	var selectedBackroundColor: UIColor? { get }

	var highlightedContentColor: UIColor? { get }
	var highlightedBackgroundColor: UIColor? { get }

	var disabledContentColor: UIColor? { get }
	var disabledBackgroundColor: UIColor? { get }

	func customize(title: String?) -> String?
	func updateAppearance()
	func customizeButton()
}

extension ButtonCustomizable where Self: UIButton {

	func customize(title: String?) -> String? {
		return title
	}

	func customizeButton() {
		contentEdgeInsets = customContentEdgeInsets
		imageEdgeInsets = customImageEdgeInsets
		titleEdgeInsets = customTitleEdgeInsets
		titleLabel?.font = titleFont
		titleLabel?.allowsDefaultTighteningForTruncation = true
		titleLabel?.adjustsFontSizeToFitWidth = true
		titleLabel?.minimumScaleFactor = 0.5
		if let image = image(for: .normal) {
			if let normalContentColor = normalContentColor {
				setImage(image.tinted(with: normalContentColor), for: .normal)
			}
			if let selectedContentColor = selectedContentColor {
				setImage(image.tinted(with: selectedContentColor), for: .selected)
			}
			if let highlightedContentColor = highlightedContentColor {
				setImage(image.tinted(with: highlightedContentColor), for: .highlighted)
			}
			if let disabledContentColor = disabledContentColor {
				setImage(image.tinted(with: disabledContentColor), for: .disabled)
			}
		}
	}

	func updateAppearance() {
		layer.cornerRadius = cornerRadius

		// FIXME: Find a nicer solution to display different states of the button.
		if isEnabled {
			if isHighlighted {
				layer.backgroundColor = highlightedBackgroundColor?.cgColor
				setTitleColor(highlightedContentColor, for: state)
			}
			else if isSelected {
				layer.backgroundColor = selectedBackroundColor?.cgColor
				setTitleColor(selectedContentColor, for: state)
			}
			else {
				layer.backgroundColor = normalBackgroundColor?.cgColor
				setTitleColor(normalContentColor, for: state)
			}
		}
		else {
			layer.backgroundColor = disabledBackgroundColor?.cgColor
			setTitleColor(disabledContentColor, for: state)
		}
	}

}
