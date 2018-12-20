//
//  NoShopsViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class NoShopsViewController: UIViewController {

	weak var container: UIViewController?
	weak var delegate: ShopMenuDelegate?

	static func instance() -> NoShopsViewController? {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		let noShopsViewController = storyboard.instantiateViewController(withIdentifier: "NoShopsViewController") as? NoShopsViewController
		return noShopsViewController
	}

	override func viewDidLoad() {
		super.viewDidLoad()

	}

	@IBAction func addShop(_ sender: Any? = nil) {
		guard let container = container
			else {
				return
		}
		let scanShopAddressViewController = ScanShopAddressViewController.present(over: container)
		scanShopAddressViewController?.delegate = self
	}

}

extension NoShopsViewController: ScanShopAddressViewControllerDelegate {

	func didScan(shop: Shop) {
		delegate?.didSelect(shop: shop)
	}

}

