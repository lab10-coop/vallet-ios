//
//  MainViewController+Admin.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

extension MainViewController {

	func setupContent(for shop: Shop) {
		shopNameLabel.text = shop.name

		viewControllers = [UIViewController]()

		guard let historyViewController = AdminHistoryViewController.instance(for: shop),
		let priceListViewController = AdminPriceListViewController.instance(for: shop)
			else {
				return
		}

		historyViewController.container = self
		priceListViewController.container = self

		viewControllers.append(historyViewController)
		viewControllers.append(priceListViewController)

		pageViewController?.setViewControllers([historyViewController], direction: .forward, animated: false, completion: { (success) in
			
		})
	}

	@IBAction func showQRCode(_ sender: Any? = nil) {
		guard let shop = shop
			else {
				return
		}
		ShopAddressViewController.present(shop: shop, over: self)
	}

}
