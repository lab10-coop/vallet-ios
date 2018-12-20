//
//  AdminPriceListCollectionHeaderView.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 04/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class AdminPriceListCollectionHeaderView: UICollectionReusableView, NibBackedCollectionReusableView {

	@IBOutlet private var editButton: UIButton!

	var isEditing = false {
		didSet {
			let buttonTitle = isEditing ? NSLocalizedString("Done", comment: "Edit button state") : NSLocalizedString("Edit", comment: "Edit button state")
			editButton.setTitle(buttonTitle)
		}
	}

	weak var delegate: AdminPriceListCollectionHeaderDelegate?

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	@IBAction func toggleEditing(_ sender: Any? = nil) {
		isEditing = !isEditing
		delegate?.didChangeEditing(to: isEditing)
	}

}

protocol AdminPriceListCollectionHeaderDelegate: class {

	func didChangeEditing(to value: Bool)

}

