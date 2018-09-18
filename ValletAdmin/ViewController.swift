//
//  ViewController.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 05/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit
import web3swift

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		print("address: \(Wallet.address)")

//		FaucetManager.getFunds(for: Wallet.address) { _ in }s
	}

	@IBAction func showSideMenu() {
		SideMenuViewController.present(over: self)
	}

	@IBAction func showSelectedShopQRCode() {
		guard let selectedShop = ShopManager.selectedShop else {
			return
		}
		ShopAddressViewController.present(shop: selectedShop, over: self)
	}

	@IBAction func startIssueFlow() {
		guard let selectedShop = ShopManager.selectedShop else {
			return
		}
		IssueAddressViewController.present(for: selectedShop, over: self)
	}

}

