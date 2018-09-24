//
//  AdminPriceListCollectionViewController.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class AdminPriceListCollectionViewController: UIViewController {

	@IBOutlet private var collectionView: UICollectionView!

	private let cellSpacing: CGFloat = 5
	private var numCellsPerRow = 2

	var shop: Shop?
	var priceListViewModel: PriceListViewModel?
	weak var container: UIViewController?

	static func instance(for shop: Shop) -> AdminPriceListCollectionViewController? {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

		guard let adminPriceListCollectionViewController = storyboard.instantiateViewController(withIdentifier: "AdminPriceListCollectionViewController") as? AdminPriceListCollectionViewController
			else {
				return nil
		}

		adminPriceListCollectionViewController.shop = shop

		return adminPriceListCollectionViewController
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		guard let shop = shop,
			let collectionView = collectionView
			else {
				return
		}

		ProductCollectionViewCell.register(for: collectionView)

		priceListViewModel = PriceListViewModel(shop: shop)
		priceListViewModel?.newDataBlock = { [weak self] in
			self?.collectionView?.reloadData()
		}

		priceListViewModel?.reload()
	}

	@IBAction func addNewProduct(_ sender: Any? = nil) {
		guard let priceListViewModel = priceListViewModel,
		let container = container
			else {
				return
		}
		CreateProductViewController.present(for: priceListViewModel, over: container)
	}

}

// MARK: - UICollectionView Data Source

extension AdminPriceListCollectionViewController: UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return priceListViewModel?.products?.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath)

		if let productCell = cell as? ProductCollectionViewCell,
			let products = priceListViewModel?.products,
			indexPath.row < products.count {
			productCell.product = products[indexPath.row]
		}

		return cell
	}

}

extension AdminPriceListCollectionViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = collectionView.frame.size.width
		let cellWidth = ((width - cellSpacing)/CGFloat(numCellsPerRow)) - cellSpacing
		let cellHeight = cellWidth * ProductCollectionViewCell.aspectRatio
		return CGSize(width: cellWidth, height: cellHeight)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return cellSpacing
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return cellSpacing
	}

}

