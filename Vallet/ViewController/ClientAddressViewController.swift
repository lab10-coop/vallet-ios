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

	static func present(over viewController: UIViewController) {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let clientAddressViewController = storyboard.instantiateViewController(withIdentifier: "ClientAddressViewController") as? ClientAddressViewController
			else {
				return
		}
		viewController.present(clientAddressViewController, animated: false)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		addressQRCodeImageView.image = UIImage.qrCode(from: Wallet.address.address, size: addressQRCodeImageView.bounds.size)
	}

	@IBAction func close(_ sender: Any? = nil) {
		dismiss(animated: true, completion: nil)
	}

}

