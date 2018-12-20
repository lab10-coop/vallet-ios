//
//  HistoryTableSectionHeaderView.swift
//  Vallet
//
//  Created by Matija Kregar on 27/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class HistoryTableSectionHeaderView: UITableViewHeaderFooterView, NibBackedTableHeaderFooterView {

	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var containerView: UIView!

	var title: String? {
		get {
			return titleLabel.text
		}
		set {
			titleLabel.text = newValue
		}
	}

	var date: Date? {
		didSet {
			guard let date = date
				else {
					titleLabel.text = ""
					return
			}
			let dateString = dateFormatter.string(from: date)
			if dateString == dateFormatter.string(from: Date()) {
				titleLabel.text = NSLocalizedString("Today", comment: "Date title")
			}
			// TODO: Do better matching
			else if dateString == "01.01.0001" {
				titleLabel.text = NSLocalizedString("Unknown date", comment: "Unknown date title")
			}
			else {
				titleLabel.text = dateString
			}
		}
	}

	private lazy var dateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM.YYYY"
		return dateFormatter
	}()

	override func awakeFromNib() {
		super.awakeFromNib()

		containerView.addRoundedCorners()
		containerView.addShadow()

		prepareForReuse()
	}

	override func prepareForReuse() {
		titleLabel.text = ""
	}

}

