//
//  ClientAddressViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 17/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class ClientAddressViewController: UIViewController {

	@IBOutlet private var addressQRCodeImageView: UIImageView!
	@IBOutlet private var contentBackgroundView: UIView!

	static func present(over viewController: UIViewController) {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let clientAddressNavigationController = storyboard.instantiateViewController(withIdentifier: "ClientAddressNavigationController") as? UINavigationController,
			let _ = clientAddressNavigationController.topViewController as? ClientAddressViewController
			else {
				return
		}
		viewController.present(clientAddressNavigationController, animated: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		contentBackgroundView.addShadow()
		contentBackgroundView.addRoundedCorners()

		guard let userAddress = QRCodeManager.userAddressCode(for: Wallet.address.address, userName: UserDefaultsManager.userName)
			else {
				return
		}

		addressQRCodeImageView.image = UIImage.qrCode(from: userAddress, size: addressQRCodeImageView.bounds.size)
	}

	@IBAction func close(_ sender: Any? = nil) {
		dismiss(animated: true, completion: nil)
	}

}

