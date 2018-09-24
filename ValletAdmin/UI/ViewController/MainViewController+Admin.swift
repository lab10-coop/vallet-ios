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

		guard let historyViewController = AdminHistoryTableViewController.instance(for: shop),
		let priceListViewController = AdminPriceListCollectionViewController.instance(for: shop)
			else {
				return
		}

		viewControllers.append(historyViewController)
		viewControllers.append(priceListViewController)

		pageViewController?.setViewControllers([historyViewController], direction: .forward, animated: false, completion: { (success) in
			
		})
	}

}
