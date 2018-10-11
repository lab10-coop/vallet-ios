//
//  AdminStartViewController.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit
import KeyboardLayoutGuide

class AdminStartViewController: UIViewController, ErrorContaining {

	@IBOutlet private var containerView: UIView!
	@IBOutlet private var nameInputView: TextInputView!
	@IBOutlet private var submitButton: UIButton!

	var error: Error?

	static func makeAppRootViewController(error: Error? = nil) {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let startViewController = storyboard.instantiateViewController(withIdentifier: "AdminStartViewController") as? AdminStartViewController,
			let appDelegate = UIApplication.shared.delegate as? AppDelegate
			else {
				return
		}

		startViewController.error = error

		appDelegate.window?.rootViewController = startViewController
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		nameInputView.type = .name
		nameInputView.maxCharacterCount = Constants.Content.maxShopNameLength
		nameInputView.returnKeyType = .send
		nameInputView.delegate = self

		containerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if let error = error {
			NotificationView.drop(error: error)
			self.error = nil
		}
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
				NotificationView.drop(error: error)
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


