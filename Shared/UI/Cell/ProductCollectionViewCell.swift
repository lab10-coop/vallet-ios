//
//  ProductCollectionViewCell.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell, NibBackedCollectionViewCell {

	@IBOutlet private var nameLabel: UILabel!
	@IBOutlet private var priceLabel: UILabel!
	@IBOutlet private var imageView: UIImageView!

	static let aspectRatio: CGFloat = 1.2

	var product: Product? {
		didSet {
			nameLabel.text = product?.name
			priceLabel.text = product?.price.description
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		prepareForReuse()
	}

	override func prepareForReuse() {
		nameLabel.text = ""
		priceLabel.text = ""
		imageView.image = nil
	}

}

