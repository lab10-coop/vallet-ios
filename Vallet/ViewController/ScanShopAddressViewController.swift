//
//  ScanShopAddressViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 18/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

protocol ScanShopAddressViewControllerDelegate: class {

	func didScan(shop: Shop)

}

class ScanShopAddressViewController: UIViewController {

	@IBOutlet private var qrCodeReaderView: QRCodeReaderView!
	@IBOutlet private var addressLabel: UILabel!

	weak var delegate: ScanShopAddressViewControllerDelegate?

	var shop: Shop?
	var shopAddress: String? {
		didSet {
			guard addressLabel != nil
				else {
					return
			}
			addressLabel.text = shopAddress
		}
	}

	@discardableResult
	static func present(over viewController: UIViewController) -> ScanShopAddressViewController? {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let scanShopAddressViewController = storyboard.instantiateViewController(withIdentifier: "ScanShopAddressViewController") as? ScanShopAddressViewController
			else {
				return nil
		}
		viewController.present(scanShopAddressViewController, animated: false)
		return scanShopAddressViewController
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		qrCodeReaderView.delegate = self
	}

	@IBAction func close(_ sender: Any? = nil) {
		dismiss(animated: true, completion: nil)
	}

	private func addShop(with address: String) {
		ShopManager.addShop(with: address) { [weak self] (result) in
			switch result {
			case .success(let shop):
				self?.delegate?.didScan(shop: shop)
				self?.close()
			case .failure(let error):
				print("Scan shop error: \(error)")
			}
		}
	}

}

extension ScanShopAddressViewController: QRCodeReaderViewDelegate {

	func didReadQRCode(value: String) {
		shopAddress = value
		addShop(with: value)
	}

}

