//
//  CreateShopViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 14/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit
import web3swift

protocol CreateShopDelegate: class {

	func didCreate(shop: Shop)

}

class CreateShopViewController: UIViewController {

	@IBOutlet private var nameInputView: TextInputView!
	@IBOutlet private var submitButton: UIButton!

	weak var delegate: CreateShopDelegate?

	@discardableResult
	static func present(over viewController: UIViewController) -> CreateShopViewController? {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let createShopNavigationController = storyboard.instantiateViewController(withIdentifier: "CreateShopNavigationController") as? UINavigationController,
			let createShopViewController = createShopNavigationController.topViewController as? CreateShopViewController
			else {
				return nil
		}
		viewController.present(createShopNavigationController, animated: false)
		return createShopViewController
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		nameInputView.type = .name
		nameInputView.returnKeyType = .send
		nameInputView.maxCharacterCount = 10
		nameInputView.delegate = self
	}

	@IBAction func close(_ sender: Any? = nil) {
		dismiss(animated: true, completion: nil)
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
			case .success(let shop):
				self?.delegate?.didCreate(shop: shop)
				self?.close()
			case .failure(let error):
				print("Create shop error: \(error)")
			}
			self?.hideActivityIndicator()
		}
	}

}


// MARK: - TextInputDelegate

extension CreateShopViewController: TextInputDelegate {

	func inputFieldHitReturnKey(_ inputField: TextInputView) {
		submit(inputField)
	}

}

