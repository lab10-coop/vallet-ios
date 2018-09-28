//
//  LabelCustomizable.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

protocol LabelCustomizable {

	var customFont: UIFont? { get }
	var customTextColor: UIColor? { get }
	var customBackgroundColor: UIColor? { get }
	func updateAppearance()

}

extension LabelCustomizable where Self: UILabel {

	var customFont: UIFont? {
		return nil
	}
	var customTextColor: UIColor? {
		return nil
	}
	var customBackgroundColor: UIColor? {
		return nil
	}

	func updateAppearance() {
		font = customFont
		textColor = customTextColor
		backgroundColor = customBackgroundColor
	}

}
