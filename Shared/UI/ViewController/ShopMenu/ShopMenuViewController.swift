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
	@IBOutlet private var containerView: UIView!
	@IBOutlet private var leftConstraint: NSLayoutConstraint!

	weak var delegate: ShopMenuDelegate?

	@discardableResult
	static func present(over viewController: UIViewController) -> ShopMenuViewController? {
		let storyboard = UIStoryboard(name: "Shared", bundle: Bundle.main)
		guard let sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "ShopMenuViewController") as? ShopMenuViewController
			else {
				return nil
		}
		viewController.present(sideMenuViewController, animated: false) {
			sideMenuViewController.show()
		}
		return sideMenuViewController
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		leftConstraint.constant = -containerView.bounds.size.width
		self.view.backgroundColor = .clear

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

	func show() {
		leftConstraint.constant = 0
		UIView.animate(withDuration: Constants.Animation.shortDuration) {
			self.view.backgroundColor = UIColor(white: 0, alpha: 0.75)
			self.view.layoutIfNeeded()
		}
	}

	func hide() {
		leftConstraint.constant = -containerView.bounds.size.width
		UIView.animate(withDuration: Constants.Animation.shortDuration, animations: {
			self.view.backgroundColor = .clear
			self.view.layoutIfNeeded()
		}) { (success) in
			self.dismiss(animated: false, completion: nil)
		}
	}

	@IBAction func createShop(_ sender: UIButton) {
		addShop()
	}

	@IBAction func didTapBackgorund(_ sender: Any) {
		print("tap bg")
		hide()
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
//			shopCell.isSelected = ShopManager.selectedShop == shopCell.shop
		}
		return cell
	}

}

extension ShopMenuViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let shop = ShopManager.shops[indexPath.row]
		ShopManager.selectedShop = shop

		delegate?.didSelect(shop: shop)
		hide()
	}
	
}

