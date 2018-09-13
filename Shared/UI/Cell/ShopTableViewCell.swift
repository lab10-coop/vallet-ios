//
//  ShopTableViewCell.swift
//  Vallet
//
//  Created by Matija Kregar on 13/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell, NibBackedTableViewCell {	

	@IBOutlet private var nameLabel: UILabel!

	var shop: Shop? {
		didSet {
			guard let shop = shop
				else {
					return
			}
			nameLabel.text = shop.name
		}
	}

	override func prepareForReuse() {
		nameLabel.text = ""
	}

}

