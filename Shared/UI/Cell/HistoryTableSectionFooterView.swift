//
//  HistoryTableSectionFooterView.swift
//  Vallet
//
//  Created by Matija Kregar on 27/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class HistoryTableSectionFooterView: UITableViewHeaderFooterView, NibBackedTableHeaderFooterView {

	@IBOutlet private var containerView: UIView!

	override func awakeFromNib() {
		super.awakeFromNib()

		containerView.addRoundedCorners()
		containerView.addShadow()
	}
	
}

