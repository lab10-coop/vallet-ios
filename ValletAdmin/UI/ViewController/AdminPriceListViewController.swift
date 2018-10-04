//
//  AdminPriceListViewController.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class AdminPriceListViewController: UIViewController {

	@IBOutlet private var collectionView: UICollectionView!

	private lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(reloadData), for: UIControl.Event.valueChanged)
		return refreshControl
	}()

	private let cellSpacing: CGFloat = 16
	private var numCellsPerRow = 2

	var shop: Shop?
	var priceListViewModel: PriceListViewModel?
	weak var container: UIViewController?

	static func instance(for shop: Shop) -> AdminPriceListViewController? {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

		guard let adminPriceListViewController = storyboard.instantiateViewController(withIdentifier: "AdminPriceListViewController") as? AdminPriceListViewController
			else {
				return nil
		}

		adminPriceListViewController.shop = shop

		return adminPriceListViewController
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		guard let shop = shop,
			let collectionView = collectionView
			else {
				return
		}

		ProductCollectionViewCell.register(for: collectionView)

		collectionView.addSubview(refreshControl)
		collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 76.0, right: 0.0)

		priceListViewModel = PriceListViewModel(shop: shop)
		priceListViewModel?.newDataBlock = { [weak self] in
			self?.refreshControl.endRefreshing()
			self?.collectionView.reloadData()
		}

		reloadData()
	}

	@objc private func reloadData() {
		priceListViewModel?.reload()
	}

	@IBAction func addNewProduct(_ sender: Any? = nil) {
		guard let priceListViewModel = priceListViewModel,
		let container = container
			else {
				return
		}
		ProductDataViewController.present(for: priceListViewModel, over: container)
	}

}

// MARK: - UICollectionView Data Source

extension AdminPriceListViewController: UICollectionViewDataSource {

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

// MARK: - UICollectionView Delegate

extension AdminPriceListViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let container = container,
			let priceListViewModel = priceListViewModel,
			let products = priceListViewModel.products,
			indexPath.row < products.count
			else {
				return
		}
		let product = products[indexPath.row]

		ProductDataViewController.present(for: priceListViewModel, product: product, over: container)
	}

}

// MARK: - UICollectionView Flow Layout

extension AdminPriceListViewController: UICollectionViewDelegateFlowLayout {

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

