//
//  ProductCollectionViewCell.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

protocol ProductCollectionViewCellDelegate: class {

	func didDelete(product: Product)

}

class ProductCollectionViewCell: UICollectionViewCell, NibBackedCollectionViewCell {

	@IBOutlet private var containerView: UIView!
	@IBOutlet private var shadowView: UIView!
	@IBOutlet private var nameLabel: UILabel!
	@IBOutlet private var priceLabel: UILabel!
	@IBOutlet private var imageView: UIImageView!
	@IBOutlet private var placeholderImageView: UIImageView!
	@IBOutlet private var deleteButton: UIButton!

	static let aspectRatio: CGFloat = 1.2

	weak var delegate: ProductCollectionViewCellDelegate?

	var canDelete: Bool = false {
		didSet {
			deleteButton.isHidden = !canDelete
		}
	}

	var product: Product? {
		didSet {
			nameLabel.text = product?.name
			if let price = product?.price {
				priceLabel.text = ShopManager.displayString(for: price)
			}
			if let image = product?.image {
				imageView.image = image
			}
			else {
				imageView.alpha = 0.0
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
		imageView.alpha = 1.0
		deleteButton.isHidden = true
	}

	@IBAction func deleteProduct(_ sender: Any? = nil) {
		guard let product = product
			else {
				return
		}
		delegate?.didDelete(product: product)
	}

}

