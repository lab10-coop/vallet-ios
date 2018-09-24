//
//  MainViewController+Client.swift
//  Vallet
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

extension MainViewController {

	func setupContent(for shop: Shop) {
		shopNameLabel.text = shop.name

		viewControllers = [UIViewController]()

		guard let historyViewController = ClientHistoryViewController.instance(for: shop),
			let priceListViewController = ClientPriceListViewController.instance(for: shop)
			else {
				return
		}

		historyViewController.container = self
		priceListViewController.container = self

		viewControllers.append(historyViewController)
		viewControllers.append(priceListViewController)

		let currentViewController = viewControllers[selectedIndex]

		pageViewController?.setViewControllers([currentViewController], direction: .forward, animated: false, completion: { (success) in

		})
	}

	@IBAction func showQRCode(_ sender: Any? = nil) {
		ClientAddressViewController.present(over: self)
	}

}
