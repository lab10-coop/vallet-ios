//
//  UIColor.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

extension UIColor {

	var redValue: CGFloat {
		return CIColor(color: self).red
	}
	var greenValue: CGFloat {
		return CIColor(color: self).green
	}
	var blueValue: CGFloat {
		return CIColor(color: self).blue
	}
	var alphaValue: CGFloat {
		return CIColor(color: self).alpha
	}

	func overlay(with overlayColor: UIColor) -> UIColor {
		guard self != .clear
			else {
				return .clear
		}

		let alpha = 1 - (1 - overlayColor.alphaValue) * (1 - alphaValue)
		let red = ((overlayColor.redValue * overlayColor.alphaValue) / alpha) + (redValue * alphaValue * (1 - overlayColor.alphaValue) / alpha)
		let green = ((overlayColor.greenValue * overlayColor.alphaValue) / alpha) + (greenValue * alphaValue * (1 - overlayColor.alphaValue) / alpha)
		let blue = ((overlayColor.blueValue * overlayColor.alphaValue) / alpha) + (blueValue * alphaValue * (1 - overlayColor.alphaValue) / alpha)
		return UIColor(red: red, green: green, blue: blue, alpha: alpha)
	}

	var darkened: UIColor {
		// Overlay 20% black.
		return self.overlay(with: UIColor(white: 0.0, alpha: 0.20))
	}

	var lightened: UIColor {
		// Overlay 80% white.
		return self.overlay(with: UIColor(white: 1.0, alpha: 0.80))
	}
	
}
