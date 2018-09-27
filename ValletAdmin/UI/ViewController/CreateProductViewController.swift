//
//  CreateProductViewController.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit
import KeyboardLayoutGuide

class CreateProductViewController: UIViewController {

	@IBOutlet private var containerView: UIView!
	@IBOutlet private var photoBackgroundView: UIView!
	@IBOutlet private var nameInputView: TextInputView!
	@IBOutlet private var priceInputView: TextInputView!
	@IBOutlet private var submitButton: UIButton!
	@IBOutlet private var cameraIconView: UIImageView!

	var priceListViewModel: PriceListViewModel?

	static func present(for viewModel: PriceListViewModel, over presenter: UIViewController) {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

		guard let navigationController = storyboard.instantiateViewController(withIdentifier: "CreateProductNavigationController") as? UINavigationController,
			let createProductViewController = navigationController.topViewController as? CreateProductViewController
			else {
				return
		}

		createProductViewController.priceListViewModel = viewModel

		presenter.present(navigationController, animated: true) {
			
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		nameInputView.returnKeyType = .next
		nameInputView.type = .name

		priceInputView.returnKeyType = .send
		priceInputView.type = .integer

		photoBackgroundView.addRoundedCorners()
		photoBackgroundView.addShadow()

		cameraIconView.tintColor = Theme.Color.lightText
		
		containerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
	}

	@IBAction func hideKeyboard(_ sender: Any? = nil) {
		nameInputView.resignFirstResponder()
		priceInputView.resignFirstResponder()
	}

	@IBAction func close(_ sender: Any? = nil) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func submit(_ sender: Any? = nil) {
		nameInputView.validate()
		priceInputView.validate()

		guard let nameInput = nameInputView.validatedText,
		let priceInput = priceInputView.validatedText,
		let price = Int(priceInput),
		let priceListViewModel = priceListViewModel
			else {
				return
		}

		nameInputView.resignFirstResponder()
		priceInputView.resignFirstResponder()

		showActivityIndicator()

		priceListViewModel.createNewProduct(named: nameInput, price: price) { [weak self] (result) in
			switch result {
			case .success:
				self?.hideActivityIndicator()
			case .failure(let error):
				print("Create new product error: \(error)")
			}
			self?.close()
		}

	}

}

extension CreateProductViewController: TextInputDelegate {

	func inputFieldHitReturnKey(_ inputField: TextInputView) {
		switch inputField {
		case nameInputView:
			priceInputView.becomeFirstResponder()
		case priceInputView:
			priceInputView.resignFirstResponder()
			submit()
		default:
			inputField.resignFirstResponder()
		}
	}

}

