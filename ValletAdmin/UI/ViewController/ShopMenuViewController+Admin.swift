//
//  ShopMenuViewController+Admin.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 18/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

extension ShopMenuViewController: ShopAddable {

	func addShop() {
		guard let createShopViewController = CreateShopViewController.present(over: self)
			else {
				return
		}
		createShopViewController.delegate = self
	}

}

extension ShopMenuViewController: CreateShopDelegate {

	func didCreate(shop: Shop) {
		shopsTableView.reloadData()
	}

}
