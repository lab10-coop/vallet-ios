//
//  MonthIOGraphView.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 08/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class MonthIOGraphView: NibLinkedView {

	@IBOutlet private var nameLabel: UILabel!

	var monthData: DashboardMonth? {
		didSet {
			setupMonth()
		}
	}

	var incomingHeight: Double = 0.0
	var outgoingHeight: Double = 0.0

	var incomingColor: UIColor = Theme.Color.incomingGraph
	var outgoingColor: UIColor = Theme.Color.outgoingGraph

	private var bottomBarMargin: CGFloat = 24.0

	override func setup() {
		super.setup()

		backgroundColor = .clear

		setupMonth()
	}

	private func setupMonth() {
		guard let monthData = monthData,
			nameLabel != nil
			else {
				return
		}

		nameLabel.text = monthData.monthName.uppercased()
		incomingHeight = monthData.normalisedIncoming
		outgoingHeight = monthData.normalisedOutgoing
		setNeedsDisplay()
	}

	private func barRect(for index: Int, height: Double) -> CGRect {
		let barWidth = 0.5 * bounds.size.width
		let fullBarHeight = bounds.size.height - bottomBarMargin
		return CGRect(x: CGFloat(index) * barWidth, y: 0.0 + fullBarHeight * (1 - CGFloat(height)), width: barWidth, height: fullBarHeight * CGFloat(height))
	}

	override func draw(_ rect: CGRect) {
		let pathI = UIBezierPath.init(rect: barRect(for: 1, height: incomingHeight))
		incomingColor.setFill()
		pathI.fill()

		let pathO = UIBezierPath.init(rect: barRect(for: 0, height: outgoingHeight))
		outgoingColor.setFill()
		pathO.fill()
	}

}

