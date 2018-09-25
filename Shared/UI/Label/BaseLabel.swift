//
//  BaseLabel.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

enum LabelMode {
	case normal
	case light
	case accent
	case error
}

class BaseLabel: UILabel, LabelCustomizable {

	var mode: LabelMode {
		return .normal
	}

	var customFont: UIFont? {
		return Theme.Font.bodyFont
	}

	var customTextColor: UIColor? {
		switch mode {
		case .normal:
			return Theme.Color.darkText
		case .light:
			return Theme.Color.lightText
		case .accent:
			return Theme.Color.accent
		case .error:
			return Theme.Color.error
		}
	}

	var customBackgroundColor: UIColor? {
		return UIColor.clear
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		updateAppearance()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		updateAppearance()
	}

}

