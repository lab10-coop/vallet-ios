//
//  DotsActivityIndicator.swift
//  Vallet
//
//  Created by Matija Kregar on 09/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class DotsActivityIndicator: UIView {

	var stackView: UIStackView?
	let dotDiameter: CGFloat = 6.0

	let dotColor = Theme.Color.darkText

	private (set) var isAnimating = false

	override func awakeFromNib() {
		backgroundColor = .clear

		var dots = [UIView]()
		for _ in 0..<3 {
			let dot = UIView(frame: CGRect(x: 0.0, y: 0.0, width: dotDiameter, height: dotDiameter))
			let widthConstraint = NSLayoutConstraint(item: dot, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: dotDiameter)
			let heightConstraint = NSLayoutConstraint(item: dot, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: dotDiameter)
			dot.addConstraints([widthConstraint, heightConstraint])
			dot.layer.cornerRadius = 0.5 * dotDiameter
			dot.backgroundColor = dotColor
			dot.alpha = 0.0
			dots.append(dot)
		}

		let stackView = UIStackView(arrangedSubviews: dots)
		stackView.axis = .horizontal
		stackView.distribution = .equalCentering
		stackView.alignment = .center
		stackView.frame = bounds
		stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(stackView)
		self.stackView = stackView
	}

	func startAnimating() {
		guard let stackView = stackView,
			isAnimating == false
			else {
				return
		}

		isAnimating = true

		for (i, dot) in stackView.arrangedSubviews.enumerated() {
			dot.alpha = 0.2
			UIView.animate(withDuration: 0.6, delay: Double(i) * 0.3, options: [.repeat, .autoreverse], animations: {
				dot.alpha = 1.0
			}, completion: nil)
		}

		UIView.animate(withDuration: 0.6) {
			self.alpha = 1
		}
	}

	func stopAnimating() {
		guard let stackView = stackView,
			isAnimating == true
			else {
				return
		}

		isAnimating = false

		for (i, dot) in stackView.arrangedSubviews.enumerated() {
			dot.layer.removeAllAnimations()
			dot.alpha = 0.6
			UIView.animate(withDuration: 0.6, delay: Double(i) * 0.3, options: [], animations: {
				dot.alpha = 0.0
			}, completion: nil)
		}

		UIView.animate(withDuration: 0.6) {
			self.alpha = 0
		}
	}

}
