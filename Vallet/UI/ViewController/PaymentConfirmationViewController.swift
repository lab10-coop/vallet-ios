//
//  PaymentConfirmationViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class PaymentConfirmationViewController: UIViewController {

	@IBOutlet private var priceLabel: UILabel!
	@IBOutlet private var nameLabel: UILabel!
	@IBOutlet private var contentBackgroundView: UIView!

	private var product: Product?
	var confirmation: (() -> Void) = {}

	static func present(for product: Product, over presenter: UIViewController, confirmation action: @escaping () -> Void) {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let paymentConfirmationViewController = storyboard.instantiateViewController(withIdentifier: "PaymentConfirmationViewController") as? PaymentConfirmationViewController
			else {
				return
		}

		paymentConfirmationViewController.product = product
		paymentConfirmationViewController.confirmation = action
		presenter.present(paymentConfirmationViewController, animated: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		contentBackgroundView.addRoundedCorners()

		if let price = product?.price {
			priceLabel.text = ShopManager.displayString(for: price)
		}
		nameLabel.text = product?.name
	}

	@IBAction func confirm(_ sender: Any? = nil) {
		confirmation()
		close()
	}

	@IBAction func close(_ sender: Any? = nil) {
		dismiss(animated: true, completion: nil)
	}

}

