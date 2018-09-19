//
//  ViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 05/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	var shopViewModel: ShopViewModel?

	override func viewDidLoad() {
		super.viewDidLoad()

		FaucetManager.getFunds(for: Wallet.address) { _ in }
	}

	@IBAction func showAddress(_ sender: Any? = nil) {
		ClientAddressViewController.present(over: self)
	}

	@IBAction func showSideMenu() {
		SideMenuViewController.present(over: self)
	}

	@IBAction func loadHistory() {
		guard let shop = ShopManager.selectedShop
			else {
				return
		}
		ClientHistoryTableViewController.present(for: shop, over: self)
	}

	@IBAction func redeem() {
		guard let shop = ShopManager.selectedShop
			else {
				return
		}

		shopViewModel = ShopViewModel(with: shop)

		shopViewModel?.redeem(amount: 1, completion: { (result) in
			print(result)
		})
	}

}
