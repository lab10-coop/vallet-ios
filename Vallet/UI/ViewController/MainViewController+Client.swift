//
//  MainViewController+Client.swift
//  Vallet
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

extension MainViewController {

	func setupMenu() {
		contentSegmentedView.segmentNames = [NSLocalizedString("Pricelist", comment: "Tab name"), NSLocalizedString("History", comment: "Tab name")]
	}

	func setupContent(for shop: Shop?) {
		guard let shop = shop
			else {
				shopNameLabel.text = ""
				addNoShopsViewController()

				balanceActivityIndicator.isHidden = true
				clientBalanceLabel.isHidden = true
				clientBalanceLabel.text = ""
				viewControllers = [UIViewController]()
				return
		}

		shopNameLabel.text = shop.name

		balanceActivityIndicator.isHidden = false
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

		viewControllers.append(priceListViewController)
		viewControllers.append(historyViewController)

		let currentViewController = viewControllers[selectedIndex]

		pageViewController?.setViewControllers([currentViewController], direction: .forward, animated: false, completion: { (success) in
		})

		NotificationCenter.default.addObserver(self, selector: #selector(updateBalance), name: Constants.Notification.newValueEvent, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateBalance), name: Constants.Notification.valueEventsUpdate, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateBalance), name: Constants.Notification.balanceRequest, object: nil)
	}

	private func addNoShopsViewController() {
		guard let noShopsViewController = NoShopsViewController.instance()
			else {
				return
		}
		noShopsViewController.container = self
		noShopsViewController.delegate = self
		pageViewController?.setViewControllers([noShopsViewController], direction: .forward, animated: false, completion: { (success) in
		})
	}

	private func showBalanceActivityIndicator() {
		balanceActivityIndicator.startAnimating()
		UIView.animate(withDuration: Constants.Animation.defaultDuration) {
			self.clientBalanceLabel.alpha = Theme.Constants.loadingValueLabelAlpha
		}
	}

	private func hideBalanceActivityIndicator() {
		guard let shop = shop,
			PendingValueEvent.events(in: DataBaseManager.managedContext, shop: shop) == nil
			else {
				return
		}
		balanceActivityIndicator.stopAnimating()
		UIView.animate(withDuration: Constants.Animation.defaultDuration) {
			self.clientBalanceLabel.alpha = 1
		}
	}

	@objc func updateBalance() {
		showBalanceActivityIndicator()
		ShopManager.balance(for: Wallet.address, in: shop) { [weak self] (result) in
			switch result {
			case .success(let balance):
				self?.clientBalanceLabel.text = "Balance: \(CurrencyFormatter.displayString(for: balance) ?? "")"
			case .failure(let error):
				NotificationView.drop(error: error)
			}

			self?.hideBalanceActivityIndicator()
		}
	}

	@IBAction func showQRCode(_ sender: Any? = nil) {
		ClientAddressViewController.present(over: self)
	}

}
