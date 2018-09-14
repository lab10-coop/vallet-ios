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
	@IBOutlet private var closeButton: UIButton!

	weak var delegate: CreateShopDelegate?

	let shopManager = ShopManager(tokenFactoryAddress: EthereumAddress(Constants.BlockChain.tokenFactoryContractAddress), managedObjectContext: DataBaseManager.managedContext)

	override func viewDidLoad() {
		super.viewDidLoad()

		nameInputView.type = .name
		nameInputView.returnKeyType = .send
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

		_ = nameInputView.resignFirstResponder()

		createShop(named: nameInput)
	}

	private func createShop(named name: String) {
		shopManager.createShop(named: name) { [weak self] (result) in
			switch result {
			case .success(let shop):
				self?.delegate?.didCreate(shop: shop)
				self?.close()
			case .failure(let error):
				print("Create shop error: \(error)")
			}
		}
	}

}


// MARK: - TextInputDelegate

extension CreateShopViewController: TextInputDelegate {

	func inputFieldHitReturnKey(_ inputField: TextInputView) {
		submit(inputField)
	}

}

