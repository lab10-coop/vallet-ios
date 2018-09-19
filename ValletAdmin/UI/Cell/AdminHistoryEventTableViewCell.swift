//
//  AdminHistoryEventTableViewCell.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 19/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class AdminHistoryEventTableViewCell: UITableViewCell, NibBackedTableViewCell {

	@IBOutlet var descriptionLabel: UILabel!
	@IBOutlet var valueLabel: UILabel!

	var event: ValueEvent? {
		didSet {
			guard let event = event
				else {
					prepareForReuse()
					return
			}
			descriptionLabel.text = "\(event.type.description) \(event.date?.description ?? "no date")"
			valueLabel.text = event.type == ValueEventType.issue.rawValue ? "- \(event.value)" : "+ \(event.value)"
		}
	}

	override func prepareForReuse() {
		descriptionLabel.text = ""
		valueLabel.text = ""
	}

}


