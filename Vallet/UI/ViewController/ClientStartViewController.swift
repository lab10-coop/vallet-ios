//
//  ClientStartViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit
import KeyboardLayoutGuide

class ClientStartViewController: UIViewController, ErrorContaining {

	@IBOutlet private var containerView: UIView!
	@IBOutlet private var nameInputView: TextInputView!
	@IBOutlet private var submitButton: UIButton!

	var error: Error?

	static func makeAppRootViewController(error: Error? = nil) {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let startViewController = storyboard.instantiateViewController(withIdentifier: "ClientStartViewController") as? ClientStartViewController,
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

		saveUserName(name: nameInput)
	}

	private func saveUserName(name: String) {
		UserDefaultsManager.userName = name
		continueToApp()
	}

	func continueToApp() {
		MainViewController.makeAppRootViewController()
	}

}


// MARK: - TextInputDelegate

extension ClientStartViewController: TextInputDelegate {

	func inputFieldHitReturnKey(_ inputField: TextInputView) {
		submit(inputField)
	}

}


