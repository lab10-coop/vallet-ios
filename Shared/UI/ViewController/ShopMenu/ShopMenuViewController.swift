//
//  ShopMenuViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 11/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit
import web3swift

protocol ShopMenuDelegate: class {

	func didSelect(shop: Shop)

}

protocol ShopAddable {

	func addShop()

}

class ShopMenuViewController: UIViewController {

	@IBOutlet var shopsTableView: UITableView!
	@IBOutlet private var logoImageView: UIImageView!
	@IBOutlet private var createShopButton: UIButton!

	weak var delegate: ShopMenuDelegate?

	@discardableResult
	static func present(over viewController: UIViewController) -> ShopMenuViewController? {
		let storyboard = UIStoryboard(name: "Shared", bundle: Bundle.main)
		guard let navigationController = storyboard.instantiateViewController(withIdentifier: "ShopMenuNavigationController") as? UINavigationController,
			let shopMenuViewController = navigationController.topViewController as? ShopMenuViewController
			else {
				return nil
		}
		viewController.present(navigationController, animated: true) {
		}
		return shopMenuViewController
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		ShopTableViewCell.register(for: shopsTableView)
		shopsTableView.delegate = self
		shopsTableView.dataSource = self
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		shopsTableView.reloadData()

		if let selectedShop = ShopManager.selectedShop,
			let selectedIndex = ShopManager.shops.index(of: selectedShop) {
			shopsTableView.selectRow(at: IndexPath(row: selectedIndex, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.none)
		}
	}

	@IBAction func createShop(_ sender: UIButton? = nil) {
		addShop()
	}

	@IBAction func close(_ sender: Any? = nil) {
		dismiss(animated: true, completion: nil)
	}

}

extension ShopMenuViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ShopManager.shops.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ShopTableViewCell.reuseIdentifier, for: indexPath)
		if let shopCell = cell as? ShopTableViewCell {
			shopCell.shop = ShopManager.shops[indexPath.row]
		}
		return cell
	}

}

extension ShopMenuViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let shop = ShopManager.shops[indexPath.row]
		ShopManager.selectedShop = shop

		delegate?.didSelect(shop: shop)
		close()
	}
	
}

