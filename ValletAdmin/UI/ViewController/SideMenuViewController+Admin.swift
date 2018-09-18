//
//  SideMenuViewController+Admin.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 18/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

extension SideMenuViewController: ShopAddable {

	func addShop() {
		guard let createShopViewController = CreateShopViewController.present(over: self)
			else {
				return
		}
		createShopViewController.delegate = self
	}

}

extension SideMenuViewController: CreateShopDelegate {

	func didCreate(shop: Shop) {
		shopsTableView.reloadData()
	}

}
