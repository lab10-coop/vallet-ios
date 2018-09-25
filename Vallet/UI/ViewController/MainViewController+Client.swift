//
//  MainViewController+Client.swift
//  Vallet
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

extension MainViewController {

	func setupContent(for shop: Shop?) {
		guard let shop = shop
			else {
				shopNameLabel.text = ""
				return
		}

		shopNameLabel.text = shop.name

		clientBalanceLabel.isHidden = false
		clientBalanceLabel.text = ""
		updateBalance()

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

		NotificationCenter.default.addObserver(self, selector: #selector(updateBalance), name: Constants.Notification.newValueEvent, object: nil)
	}

	@objc func updateBalance() {
		ShopManager.balance(for: Wallet.address, in: shop) { [weak self] (result) in
			switch result {
			case .success(let balance):
				self?.clientBalanceLabel.text = "Balance: \(balance.description)"
			case .failure(let error):
				print("Load balance error: \(error)")
			}
		}
	}

	@IBAction func showQRCode(_ sender: Any? = nil) {
		ClientAddressViewController.present(over: self)
	}

}
