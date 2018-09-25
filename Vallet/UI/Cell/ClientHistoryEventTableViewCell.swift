//
//  ClientHistoryEventTableViewCell.swift
//  Vallet
//
//  Created by Matija Kregar on 19/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class ClientHistoryEventTableViewCell: UITableViewCell, NibBackedTableViewCell {

	@IBOutlet var descriptionLabel: UILabel!
	@IBOutlet var valueLabel: UILabel!

	private var dateOutput: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		var dateString = "no date"
		if let date = event?.date {
			dateString = dateFormatter.string(from: date)
		}
		return dateString
	}

	var event: ValueEvent? {
		didSet {
			guard let event = event
				else {
					prepareForReuse()
					return
			}
			descriptionLabel.text = "\(event.type.description) \(event.productName ?? "unknown item") \(dateOutput)"
			valueLabel.text = event.type == ValueEventType.issue.rawValue ? "+ \(event.value)" : "- \(event.value)"
		}
	}

	override func prepareForReuse() {
		descriptionLabel.text = ""
		valueLabel.text = ""
	}

}

