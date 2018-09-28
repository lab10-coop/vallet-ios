//
//  ShopMenuViewController+Client.swift
//  Vallet
//
//  Created by Matija Kregar on 18/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

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
		shopsTableView.reloadData()
	}

}
