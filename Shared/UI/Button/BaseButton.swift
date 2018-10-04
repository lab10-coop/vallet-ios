//
//  BaseButton.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

public class BaseButton: UIButton, ButtonCustomizable {

	// MARK: - ButtonCustomizable Shape
	var cornerRadius: CGFloat {
		return 0.0
	}
	var customContentEdgeInsets: UIEdgeInsets {
		return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
	}
	var customTitleEdgeInsets: UIEdgeInsets {
		return UIEdgeInsets.zero
	}
	var customImageEdgeInsets: UIEdgeInsets {
		return UIEdgeInsets.zero
	}

	// MARK: - ButtonCustomizable Font
	var titleFont: UIFont? {
		return nil
	}

	// MARK: - ButtonCustomizable Colors
	var normalContentColor: UIColor? {
		return Theme.Color.defaultButtonContent
	}
	var normalBackgroundColor: UIColor? {
		return Theme.Color.defaultButtonBackground
	}

	var selectedContentColor: UIColor? {
		return normalContentColor?.darkened
	}
	var selectedBackroundColor: UIColor? {
		return normalBackgroundColor?.darkened
	}

	var highlightedContentColor: UIColor? {
		return normalContentColor?.darkened
	}
	var highlightedBackgroundColor: UIColor? {
		return normalBackgroundColor?.darkened
	}

	var disabledContentColor: UIColor? {
		return normalContentColor?.lightened
	}
	var disabledBackgroundColor: UIColor? {
		return normalBackgroundColor?.lightened
	}

	func customize(title: String?) -> String? {
		return title
	}

	// MARK: - Overrides
	override func setTitle(_ title: String?) {
		allStates.forEach {
			setTitle(customize(title: title), for: $0)
		}
	}

	override open func awakeFromNib() {
		super.awakeFromNib()

		allStates.forEach { state in
			let customizedTitle = customize(title: title(for: state))
			setTitle(customizedTitle, for: state)
		}

		customizeButton()
	}

	public override func layoutSubviews() {
		super.layoutSubviews()

		updateAppearance()
	}

}
