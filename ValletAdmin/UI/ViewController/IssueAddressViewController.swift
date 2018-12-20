//
//  IssueAddressViewController.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 14/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class IssueAddressViewController: UIViewController {
	
	@IBOutlet private var qrCodeReaderView: QRCodeReaderView!
	@IBOutlet private var qrCodeReaderBackgroundView: UIView!
	@IBOutlet private var continueButton: UIButton!
	@IBOutlet private var scanAgainButton: UIButton!
	
	var issueViewModel: IssueViewModel?
	
	weak var delegate: IssueViewControllerDelegate?
	
	var shop: Shop?
	var clientAddress: String? {
		didSet {
			issueViewModel?.clientAddress = clientAddress
		}
	}
	
	@discardableResult
	static func present(for shop: Shop, over viewController: UIViewController) -> IssueAddressViewController? {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		
		guard let issueNavigationController = storyboard.instantiateViewController(withIdentifier: "IssueNavigationViewController") as? UINavigationController,
			let issueAddressViewController = issueNavigationController.viewControllers.first as? IssueAddressViewController
			else {
				return nil
		}
		
		issueAddressViewController.shop = shop
		
		viewController.present(issueNavigationController, animated: true)
		return issueAddressViewController
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let shop = ShopManager.selectedShop
			else {
				return
		}
		
		qrCodeReaderBackgroundView.addRoundedCorners()
		qrCodeReaderBackgroundView.addShadow()
		
		scanAgainButton.isEnabled = false
		continueButton.isEnabled = false
		
		qrCodeReaderView.delegate = self
		
		issueViewModel = IssueViewModel(with: shop)
		
		PrivacyPermissionsManager.getPermission(for: .camera) { [weak self] (type, isGranted) in
			if !isGranted {
				guard let strongSelf = self
					else {
						return
				}
				PrivacyPermissionsManager.presentSettingsAlert(for: type, in: strongSelf)
			}
		}
	}
	
	@IBAction func close(_ sender: Any? = nil) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func scanAgain(_ sender: Any? = nil) {
		qrCodeReaderView.startScanning()
		continueButton.isEnabled = false
	}
	
	// MARK: - User
	
	func saveUser(from code: String) {
		do {
			let address = try QRCodeManager.userAddress(from: code)
			let name = QRCodeManager.userName(from: code)
			
			let managedObjectContext = DataBaseManager.managedContext
			
			if let existingUser = User.user(in: managedObjectContext, with: address) {
				existingUser.name = name
				DataBaseManager.save(managedContext: managedObjectContext)
				return
			}
			
			guard User(in: managedObjectContext, address: address, name: name) != nil
				else {
					return
			}
			
			DataBaseManager.save(managedContext: managedObjectContext)
		}
		catch {
			NotificationView.drop(error: error)
		}
	}
	
	// MARK: - Navigation
	
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		switch identifier {
		case "ShowIssueAmountViewControllerSegue":
			return issueViewModel?.clientAddress != nil
		default:
			return true
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case "ShowIssueAmountViewControllerSegue":
			if let issueAmountViewController = segue.destination as? IssueAmountViewController {
				issueAmountViewController.issueViewModel = issueViewModel
				issueAmountViewController.delegate = self.delegate
			}
		default:
			break
		}
	}
	
}

extension IssueAddressViewController: QRCodeReaderViewDelegate {
	
	func didReadQRCode(value: String) {
		do {
			let userAddress = try QRCodeManager.userAddress(from: value)
			saveUser(from: value)
			
			continueButton.isEnabled = true
			scanAgainButton.isEnabled = true
			clientAddress = userAddress
		}
		catch {
			NotificationView.drop(error: error)
			continueButton.isEnabled = false
			scanAgainButton.isEnabled = true
		}
	}
	
}

