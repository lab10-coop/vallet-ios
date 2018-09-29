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

	var event: ValueEvent? {
		didSet {
			guard let event = event,
				let type = event.resolvedType
				else {
					prepareForReuse()
					return
			}

			switch type {
			case .issue:
				outgoingImageView.tintColor = Theme.Color.accent
				outgoingImageView.isHidden = false
				descriptionLabel.text = NSLocalizedString("Sent", comment: "Admin issue event description")
				if let clientName = event.client?.name {
					descriptionLabel.text?.append(" \(NSLocalizedString("to", comment: "")) \(clientName)")
				}
				valueLabel.text = "- \(event.value)"
				valueLabel.textColor = Theme.Color.darkText
			case .redeem:
				incomingImageView.tintColor = Theme.Color.accent
				incomingImageView.isHidden = false
				descriptionLabel.text = NSLocalizedString("Received", comment: "Admin receive event description")
				if let clientName = event.client?.name {
					descriptionLabel.text?.append(" \(NSLocalizedString("from", comment: "")) \(clientName)")
				}
				valueLabel.text = "+ \(event.value)"
				valueLabel.textColor = Theme.Color.accent
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
		incomingImageView.isHidden = true
		outgoingImageView.isHidden = true
		descriptionLabel.text = ""
		valueLabel.text = ""
	}

}


