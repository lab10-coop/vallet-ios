//
//  SecondaryButton.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class SecondaryButton: BaseButton {

	override var titleFont: UIFont? {
		return Theme.Font.largeButtonFont
	}

	override var normalBackgroundColor: UIColor? {
		return Theme.Color.defaultButtonBackground
	}

	override var normalContentColor: UIColor? {
		return Theme.Color.defaultButtonContent
	}

	override var customContentEdgeInsets: UIEdgeInsets {
		if image(for: .normal) != nil {
			return UIEdgeInsets(top: 4.0, left: 7.0, bottom: 4.0, right: 7.0)
		}
		return UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
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

}
