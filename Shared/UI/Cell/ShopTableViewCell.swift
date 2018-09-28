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
	@IBOutlet private var selectionView: UIView!

	var shop: Shop? {
		didSet {
			guard let shop = shop
				else {
					return
			}
			nameLabel.text = shop.name
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		selectionView.backgroundColor = Theme.Color.accent
		selectionView.alpha = 0.15
		selectionView.layer.cornerRadius = 6.0
		prepareForReuse()
	}

	override func prepareForReuse() {
		nameLabel.text = ""
		selectionView.isHidden = true
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		selectionView.isHidden = !selected
	}

}

