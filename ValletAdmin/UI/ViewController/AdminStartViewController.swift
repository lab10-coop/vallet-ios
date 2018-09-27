//
//  AdminStartViewController.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit
import KeyboardLayoutGuide

class AdminStartViewController: UIViewController {

	@IBOutlet private var containerView: UIView!
	@IBOutlet private var nameInputView: TextInputView!
	@IBOutlet private var submitButton: UIButton!

	static func makeAppRootViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let startViewController = storyboard.instantiateViewController(withIdentifier: "AdminStartViewController") as? AdminStartViewController,
			let appDelegate = UIApplication.shared.delegate as? AppDelegate
			else {
				return
		}

		appDelegate.window?.rootViewController = startViewController
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		nameInputView.type = .name
		nameInputView.returnKeyType = .send
		nameInputView.delegate = self

		FaucetManager.getFunds(for: Wallet.address) { result in
			print("Get funds result: \(result)")
		}

		containerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
	}

	@IBAction func hideKeyboard(_ sender: Any? = nil) {
		nameInputView.resignFirstResponder()
	}

	@IBAction func submit(_ sender: Any? = nil) {
		nameInputView.validate()

		guard let nameInput = nameInputView.validatedText
			else {
				return
		}

		nameInputView.resignFirstResponder()

		createShop(named: nameInput)
	}

	private func createShop(named name: String) {
		showActivityIndicator()
		
		ShopManager.createShop(named: name) { [weak self] (result) in
			switch result {
			case .success:
				self?.continueToApp()
			case .failure(let error):
				print("Create shop error: \(error)")
			}
			self?.hideActivityIndicator()
		}
	}

	func continueToApp() {
		MainViewController.makeAppRootViewController()
	}

}


// MARK: - TextInputDelegate

extension AdminStartViewController: TextInputDelegate {

	func inputFieldHitReturnKey(_ inputField: TextInputView) {
		submit(inputField)
	}

}


