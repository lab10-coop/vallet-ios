//
//  ShopMenuViewController+Client.swift
//  Vallet
//
//  Created by Matija Kregar on 18/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

extension ShopMenuViewController {

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if (editingStyle == UITableViewCell.EditingStyle.delete) {
			print("delete")
			let shop = ShopManager.shops[indexPath.row]
			ShopManager.delete(shop: shop)
			refreshView()
		}
	}

}

extension ShopMenuViewController: ShopAddable {

	func addShop() {
		guard let scanShopAddressViewController = ScanShopAddressViewController.present(over: self)
			else {
				return
		}
		scanShopAddressViewController.delegate = self
	}

}

extension ShopMenuViewController: ScanShopAddressViewControllerDelegate {

	func didScan(shop: Shop) {
		refreshView()
	}

}
