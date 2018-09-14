//
//  SideMenuViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 11/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit
import web3swift

protocol SideMenuDelegate: class {

	func didSelect(shop: Shop)

}

class SideMenuViewController: UIViewController {

	@IBOutlet private var logoImageView: UIImageView!
	@IBOutlet private var shopsTableView: UITableView!
	@IBOutlet private var createShopButton: UIButton!
	@IBOutlet private var containerView: UIView!
	@IBOutlet private var leftConstraint: NSLayoutConstraint!

	weak var delegate: SideMenuDelegate?

	let shopManager = ShopManager(tokenFactoryAddress: EthereumAddress(Constants.BlockChain.tokenFactoryContractAddress), managedObjectContext: DataBaseManager.managedContext)

	static func present(over viewController: UIViewController) {
		let storyboard = UIStoryboard(name: "Shared", bundle: Bundle.main)
		guard let sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
			else {
				return
		}
		viewController.present(sideMenuViewController, animated: false) {
			sideMenuViewController.show()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		leftConstraint.constant = -containerView.bounds.size.width
		self.view.backgroundColor = .clear

		ShopTableViewCell.register(for: shopsTableView)
		shopsTableView.delegate = self
		shopsTableView.dataSource = self
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
		print("create shop")
	}

	@IBAction func didTapBackgorund(_ sender: Any) {
		print("tap bg")
		hide()
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case "PresentCreateNewShopViewController":
			guard let createShopViewController = segue.destination as? CreateShopViewController
				else {
					return
			}
			createShopViewController.delegate = self
		default:
			break
		}
	}

}

extension SideMenuViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return shopManager.shops.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ShopTableViewCell.reuseIdentifier, for: indexPath)
		if let shopCell = cell as? ShopTableViewCell {
			shopCell.shop = shopManager.shops[indexPath.row]
		}
		return cell
	}

}

extension SideMenuViewController: UITableViewDelegate {

}

extension SideMenuViewController: CreateShopDelegate {

	func didCreate(shop: Shop) {
		shopsTableView.reloadData()
	}

}

