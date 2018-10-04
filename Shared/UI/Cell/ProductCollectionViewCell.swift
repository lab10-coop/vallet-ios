//
//  ProductCollectionViewCell.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell, NibBackedCollectionViewCell {

	@IBOutlet private var containerView: UIView!
	@IBOutlet private var shadowView: UIView!
	@IBOutlet private var nameLabel: UILabel!
	@IBOutlet private var priceLabel: UILabel!
	@IBOutlet private var imageView: UIImageView!
	@IBOutlet private var placeholderImageView: UIImageView!

	static let aspectRatio: CGFloat = 1.2

	var product: Product? {
		didSet {
			nameLabel.text = product?.name
			priceLabel.text = product?.price.description
			if let image = product?.image {
				imageView.image = image
				imageView.fadeIn()
			}
			else {
				product?.updateImage(completion: { [weak self] (imageResult) in
					guard case .success(let image) = imageResult
						else {
							return
					}
					self?.imageView.image = image
					self?.imageView.fadeIn()
				})
			}
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		backgroundColor = Theme.Color.background

		shadowView.addShadow()
		shadowView.addRoundedCorners()
		
		containerView.addRoundedCorners()

		placeholderImageView.tintColor = Theme.Color.separator
		
		prepareForReuse()
	}

	override func prepareForReuse() {
		nameLabel.text = ""
		priceLabel.text = ""
		imageView.image = nil
		imageView.alpha = 0.0
	}

}

