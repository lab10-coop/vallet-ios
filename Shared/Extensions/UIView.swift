//
//  UIView.swift
//  Vallet
//
//  Created by Matija Kregar on 14/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

struct ViewTag {
	static let bottomBorder = 10002
}

extension UIView {

	public func addBottomBorder(_ width: CGFloat, color: UIColor?) {
		let border = UIView()
		border.tag = ViewTag.bottomBorder
		border.backgroundColor = color
		addSubview(border)

		border.translatesAutoresizingMaskIntoConstraints = false
		let views = ["border": border]
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[border(\(width))]-(0)-|", options: NSLayoutFormatOptions.alignAllBottom, metrics: nil, views: views))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[border]-(0)-|", options: NSLayoutFormatOptions.alignAllBottom, metrics: nil, views: views))
	}

	public func bottomBorder() -> UIView? {
		return viewWithTag(ViewTag.bottomBorder)
	}

	func fadeIn(withDuration duration: TimeInterval = 0.4, completion: ((Bool) -> Void)? = nil) {
		isHidden = false
		UIView.animate(withDuration: duration, animations: {
			self.alpha = 1
		}) { (success) in
			completion?(success)
		}
	}

	func fadeOut(withDuration duration: TimeInterval = 0.4, completion: ((Bool) -> Void)? = nil) {
		UIView.animate(withDuration: duration, animations: {
			self.alpha = 0
		}) { (success) in
			completion?(success)
		}
	}

}
