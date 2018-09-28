//
//  SegmentedControlView.swift
//  CornerLabelTest
//
//  Created by Matija Kregar on 27/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

protocol SegmentedControlViewDelegate: class {

	func didChangeSelected(to index: Int)

}

class SegmentedControlView: NibLinkedView {

	@IBOutlet private var indicatorView: UIView!
	@IBOutlet private var labelsStackView: UIStackView!
	@IBOutlet private var buttonsStackView: UIStackView!

	@IBOutlet private var indicatorWidthConstraint: NSLayoutConstraint!
	@IBOutlet private var indicatorCenterConstraint: NSLayoutConstraint!

	weak var delegate: SegmentedControlViewDelegate?

	var selectedIndex: Int = 0 {
		didSet {
			guard selectedIndex < labelsStackView.arrangedSubviews.count
				else {
					return
			}

			delegate?.didChangeSelected(to: selectedIndex)

			adjustTo(selectedIndex: selectedIndex)
			UIView.animate(withDuration: 0.3) {
				self.setNeedsLayout()
				self.layoutIfNeeded()
			}
		}
	}

	var segmentNames = [String]() {
		didSet {
			removeAllSegments()
			for name in segmentNames {
				addSegment(named: name)
			}
		}
	}

	var indicatorMargins: CGFloat = 8.0

	override func setup() {
		indicatorView.backgroundColor = Theme.Color.accent
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		adjustTo(selectedIndex: selectedIndex)
	}

	@objc func changeSelectedIndex(_ sender: UIButton) {
		guard selectedIndex != sender.tag
			else {
				return
		}
		selectedIndex = sender.tag
	}

	func addSegment(named name: String) {
		let newLabel = TitleLabel(frame: CGRect.zero)
		newLabel.textAlignment = .center
		newLabel.text = name
		labelsStackView.addArrangedSubview(newLabel)

		let newButton = UIButton(type: .custom)
		newButton.tag = labelsStackView.arrangedSubviews.count - 1
		newButton.addTarget(self, action: #selector(changeSelectedIndex(_:)), for: UIControl.Event.touchUpInside)
		buttonsStackView.addArrangedSubview(newButton)
	}

	private func removeAllSegments() {
		for label in labelsStackView.arrangedSubviews {
			labelsStackView.removeArrangedSubview(label)
			label.removeFromSuperview()
		}
		for button in buttonsStackView.arrangedSubviews {
			buttonsStackView.removeArrangedSubview(button)
			button.removeFromSuperview()
		}
	}

	private func adjustTo(selectedIndex: Int) {
		let width = bounds.size.width
		let segmentWidth = width / CGFloat(labelsStackView.arrangedSubviews.count)
		indicatorWidthConstraint.constant = segmentWidth - 2 * indicatorMargins
		let segmentCenter = (CGFloat(selectedIndex) + 0.5) * segmentWidth

		indicatorCenterConstraint.constant = segmentCenter

		for (i, label) in labelsStackView.arrangedSubviews.enumerated() {
			label.alpha = i == selectedIndex ? 1 : 0.4
		}
	}

}
