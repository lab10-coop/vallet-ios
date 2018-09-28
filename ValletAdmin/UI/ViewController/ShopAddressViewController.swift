//
//  ShopAddressViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 14/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class ShopAddressViewController: UIViewController {

	@IBOutlet private var shopNameLabel: UILabel!
	@IBOutlet private var qrCodeImageView: UIImageView!
	@IBOutlet private var contentBackgroundView: UIView!

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
		guard let shopAddressNavigationController = storyboard.instantiateViewController(withIdentifier: "ShopAddressNavigationController") as? UINavigationController,
			let shopAddressViewController = shopAddressNavigationController.topViewController as? ShopAddressViewController
			else {
				return
		}

		shopAddressViewController.shop = shop
		viewController.present(shopAddressNavigationController, animated: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		contentBackgroundView.addShadow()
		contentBackgroundView.addRoundedCorners()
		
		setQRCodeImage(for: shop)
	}

	private func setQRCodeImage(for shop: Shop?) {
		guard let shop = shop,
			let shopAddress = shop.address
			else {
				qrCodeImageView.image = nil
				return
		}
		shopNameLabel.text = shop.name

		let shopAddressCode = QRCodeManager.shopAddressCode(for: shopAddress)
		qrCodeImageView.image = UIImage.qrCode(from: shopAddressCode, size: qrCodeImageView.bounds.size)
	}

	@IBAction func close(_ sender: Any? = nil) {
		dismiss(animated: true, completion: nil)
	}

}
