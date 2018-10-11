//
//  AdminHistoryEventTableViewCell.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 19/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class AdminHistoryEventTableViewCell: UITableViewCell, NibBackedTableViewCell {

	@IBOutlet private var descriptionLabel: UILabel!
	@IBOutlet private var valueLabel: UILabel!
	@IBOutlet private var incomingImageView: UIImageView!
	@IBOutlet private var outgoingImageView: UIImageView!
	@IBOutlet private var shadowView: UIView!
	@IBOutlet private var statusLabel: UILabel!

	var event: EventValuable? {
		didSet {
			guard let event = event,
				let type = event.type,
				let value = CurrencyFormatter.displayString(for: event.value)
				else {
					prepareForReuse()
					return
			}

			switch type {
			case .issue:
				outgoingImageView.tintColor = Theme.Color.accent
				outgoingImageView.alpha = 1.0
				descriptionLabel.text = NSLocalizedString("Sent", comment: "Admin issue event description")
				if let clientName = event.client?.name {
					descriptionLabel.text?.append(" \(NSLocalizedString("to", comment: "")) \(clientName)")
				}
				valueLabel.text = "- \(value)"
				valueLabel.textColor = Theme.Color.darkText
			case .redeem:
				incomingImageView.tintColor = Theme.Color.accent
				incomingImageView.alpha = 1.0
				descriptionLabel.text = NSLocalizedString("Received", comment: "Admin receive event description")
				if let clientName = event.client?.name {
					descriptionLabel.text?.append(" \(NSLocalizedString("from", comment: "")) \(clientName)")
				}
				valueLabel.text = "+ \(value)"
				valueLabel.textColor = Theme.Color.accent
			}

			// Display status if it's not OK.
			if let valueEvent = event as? ValueEvent,
				let status = valueEvent.status,
				status != .ok {
				incomingImageView.tintColor = Theme.Color.error
				outgoingImageView.tintColor = Theme.Color.error
				statusLabel.isHidden = false
				statusLabel.text = status == .failed ? NSLocalizedString("Failed", comment: "Event status") : NSLocalizedString("Not yet processed", comment: "Event status")
			}
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		shadowView.addRoundedCorners()
		shadowView.addShadow()

		prepareForReuse()
	}

	override func prepareForReuse() {
		incomingImageView.alpha = 0.0
		outgoingImageView.alpha = 0.0
		descriptionLabel.text = ""
		valueLabel.text = ""
		statusLabel.text = ""
		statusLabel.isHidden = true
	}

}


