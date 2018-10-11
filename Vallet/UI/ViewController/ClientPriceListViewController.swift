//
//  ClientPriceListViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class ClientPriceListViewController: UIViewController {

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

	static func instance(for shop: Shop) -> ClientPriceListViewController? {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

		guard let clientPriceListViewController = storyboard.instantiateViewController(withIdentifier: "ClientPriceListViewController") as? ClientPriceListViewController
			else {
				return nil
		}

		clientPriceListViewController.shop = shop

		return clientPriceListViewController
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
		collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 16.0, right: 0.0)

		priceListViewModel = PriceListViewModel(shop: shop, newDataBlock: { [weak self] in
			self?.refreshControl.endRefreshing()
			self?.collectionView.reloadData()
		})

		reloadData()
	}

	@objc private func reloadData() {
		priceListViewModel?.reload()
		NotificationCenter.default.post(name: Constants.Notification.balanceRequest, object: nil)
	}

	func triggerPayment(for product: Product) {
		container?.showActivityIndicator()
		priceListViewModel?.pay(for: product) { [weak self] (result) in
			switch result {
			case .success(let pendingValueEvent):
				self?.priceListViewModel?.makeValueEvent(from: pendingValueEvent, completion: { (result) in
					switch result {
					case .success:
						break
					case .failure(let error):
						NotificationView.drop(error: error)
					}
				})
				NotificationCenter.default.post(name: Constants.Notification.valueEventsUpdate, object: nil)
			case .failure(let error):
				NotificationView.drop(error: error)
			}
			self?.container?.hideActivityIndicator()
		}
	}

}

// MARK: - UICollectionView Data Source

extension ClientPriceListViewController: UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return priceListViewModel?.products.count ?? 0
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

extension ClientPriceListViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let container = container,
			let priceListViewModel = priceListViewModel,
			indexPath.row < priceListViewModel.products.count
			else {
				return
		}
		let product = priceListViewModel.products[indexPath.row]

		if let balance = ShopManager.savedBalance,
			balance < product.price {
			NotificationView.drop(error: ValletError.insuficientFunds)
			return
		}

		PaymentConfirmationViewController.present(for: product, over: container) { [weak self] in
			self?.triggerPayment(for: product)
		}
	}

}

// MARK: - UICollectionView Flow Layout

extension ClientPriceListViewController: UICollectionViewDelegateFlowLayout {

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

