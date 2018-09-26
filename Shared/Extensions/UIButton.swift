//
//  UIButton.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

extension UIButton {

	var allStates: [UIControlState] {
		return [.normal, .selected, .highlighted, .disabled]
	}

	@objc func setTitle(_ title: String?) {
		allStates.forEach {
			setTitle(title, for: $0)
		}
	}

}
