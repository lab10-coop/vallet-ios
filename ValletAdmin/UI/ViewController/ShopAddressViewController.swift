//
//  ShopAddressViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 14/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class ShopAddressViewController: UIViewController {

	@IBOutlet private var qrCodeImageView: UIImageView!

	var shop: Shop? {
		didSet {
			guard qrCodeImageView != nil
				else {
					return
			}
			setQRCodeImage(for: shop)
		}
	}

	static func present(shop: Shop, over viewController: UIViewController) {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let shopAddressViewController = storyboard.instantiateViewController(withIdentifier: "ShopAddressViewController") as? ShopAddressViewController
			else {
				return
		}
		shopAddressViewController.shop = shop
		viewController.present(shopAddressViewController, animated: false)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setQRCodeImage(for: shop)
	}

	private func setQRCodeImage(for shop: Shop?) {
		guard let shop = shop,
			let shopAddress = shop.address
			else {
				qrCodeImageView.image = nil
				return
		}
		qrCodeImageView.image = UIImage.qrCode(from: shopAddress, size: qrCodeImageView.bounds.size)
	}

	@IBAction func close(_ sender: Any? = nil) {
		dismiss(animated: true, completion: nil)
	}

}
