//
//  ClientStartViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class ClientStartViewController: UIViewController {

	@IBOutlet private var nameInputView: TextInputView!
	@IBOutlet private var submitButton: UIButton!


	static func makeAppRootViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let startViewController = storyboard.instantiateViewController(withIdentifier: "ClientStartViewController") as? ClientStartViewController,
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


