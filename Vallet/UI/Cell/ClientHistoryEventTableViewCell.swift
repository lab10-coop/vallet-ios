//
//  ClientHistoryEventTableViewCell.swift
//  Vallet
//
//  Created by Matija Kregar on 19/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class ClientHistoryEventTableViewCell: UITableViewCell, NibBackedTableViewCell {

	@IBOutlet private var descriptionLabel: UILabel!
	@IBOutlet private var valueLabel: UILabel!
	@IBOutlet private var incomingImageView: UIImageView!
	@IBOutlet private var outgoingImageView: UIImageView!
	@IBOutlet private var shadowView: UIView!

	var event: ValueEvent? {
		didSet {
			guard let event = event,
				let type = event.resolvedType,
				let value = CurrencyFormatter.displayString(for: event.value)
				else {
					prepareForReuse()
					return
			}

			switch type {
			case .redeem:
				outgoingImageView.tintColor = Theme.Color.accent
				outgoingImageView.isHidden = false
				descriptionLabel.text = event.productName ?? NSLocalizedString("Unknow Item", comment: "Unknown item name")
				valueLabel.text = "- \(value)"
				valueLabel.textColor = Theme.Color.darkText
			case .issue:
				incomingImageView.tintColor = Theme.Color.accent
				incomingImageView.isHidden = false
				descriptionLabel.text = NSLocalizedString("Incoming", comment: "Issue event description")
				valueLabel.text = "+ \(value)"
				valueLabel.textColor = Theme.Color.accent
			}
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()

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

