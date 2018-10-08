//
//  MonthsGraphView.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 08/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class MonthsGraphView: NibLinkedView {

	@IBOutlet private var monthsStackView: UIStackView!

	var monthsData = [DashboardMonth]() {
		didSet {
			setupMonths()
		}
	}

	override func setup() {
		super.setup()
		setupMonths()
	}

	private func setupMonths() {
		for view in monthsStackView.arrangedSubviews {
			monthsStackView.removeArrangedSubview(view)
			view.removeFromSuperview()
		}
		for monthData in monthsData {
			let monthView = MonthIOGraphView()
			monthView.monthData = monthData
			monthsStackView.addArrangedSubview(monthView)
		}
	}

}
