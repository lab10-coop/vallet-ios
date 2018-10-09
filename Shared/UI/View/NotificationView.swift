//
//  NotificationView.swift
//  Vallet
//
//  Created by Matija Kregar on 09/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class NotificationView: NibLinkedView {

	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var messageLabel: UILabel!
	@IBOutlet private var contentStackView: UIStackView!

	private var topConstraint: NSLayoutConstraint?
	private var heightConstraint: NSLayoutConstraint?

	private var calculatedHeight: CGFloat {
		var height: CGFloat = 0.0
		height += safeAreaInsets.top
		height += 32.0
		height += contentStackView.frame.size.height
		return height
	}

	static func drop(title: String? = nil, message: String? = nil, for duration: TimeInterval = Constants.Timer.notificationDuration) {
		removeAll()
		let dropDownView = NotificationView(frame: CGRect.zero)
		dropDownView.messageLabel.isHidden = message == nil
		dropDownView.messageLabel.text = message
		dropDownView.titleLabel.isHidden = title == nil
		dropDownView.titleLabel.text = title
		dropDownView.addToWindow()
		dropDownView.topConstraint?.constant = -dropDownView.calculatedHeight
		dropDownView.updateHeight()
		dropDownView.show(for: duration)
	}

	override func setup() {
		translatesAutoresizingMaskIntoConstraints = false

		titleLabel.textColor = .white
		messageLabel.textColor = .white
		backgroundColor = Theme.Color.error
	}

	private func updateHeight() {
		heightConstraint?.constant = calculatedHeight
		superview?.layoutIfNeeded()
	}

	private func addToWindow() {
		UIApplication.shared.keyWindow?.addSubview(self)
		guard let superview = self.window
			else {
				return
		}
		let leftConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0)
		let rightConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0)
		let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: -calculatedHeight)
		let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: calculatedHeight)

		superview.addConstraints([leftConstraint, rightConstraint, topConstraint, heightConstraint])

		self.topConstraint = topConstraint
		self.heightConstraint = heightConstraint

		superview.setNeedsLayout()
		superview.layoutIfNeeded()
	}

	private func show(for duration: TimeInterval) {
		guard let topConstraint = topConstraint,
			let superview = self.superview
			else {
				return
		}

		topConstraint.constant = 0.0

		UIView.animate(withDuration: Constants.Animation.defaultDuration, animations: {
			superview.layoutIfNeeded()
		}) { _ in
			Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { [weak self] (timer) in
				self?.hide()
			})
		}
	}

	private func hide() {
		guard let topConstraint = topConstraint,
			let superview = self.superview
			else {
				return
		}

		topConstraint.constant = -calculatedHeight

		UIView.animate(withDuration: Constants.Animation.shortDuration, animations: {
			superview.layoutIfNeeded()
		}) { _ in
			self.removeFromSuperview()
		}
	}

	static func removeAll() {
		guard let window = UIApplication.shared.keyWindow else { return }
		for view in window.subviews {
			if let notificationView = view as? NotificationView {
				notificationView.hide()
			}
		}
	}

}
