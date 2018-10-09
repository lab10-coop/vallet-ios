//
//  CreateProductViewController.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit
import KeyboardLayoutGuide

class ProductDataViewController: UIViewController {

	@IBOutlet private var containerView: UIView!
	@IBOutlet private var photoBackgroundView: UIView!
	@IBOutlet private var nameInputView: TextInputView!
	@IBOutlet private var priceInputView: TextInputView!
	@IBOutlet private var saveButton: UIButton!
	@IBOutlet private var cameraIconView: UIImageView!
	@IBOutlet private var productImageView: UIImageView!

	var priceListViewModel: PriceListViewModel?

	var productImage: UIImage? {
		didSet {
			productImageView.image = productImage
		}
	}

	var product: Product? {
		didSet {
			setup(product: product)
		}
	}

	static func present(for viewModel: PriceListViewModel, product: Product? = nil, over presenter: UIViewController) {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

		guard let navigationController = storyboard.instantiateViewController(withIdentifier: "ProductDataNavigationController") as? UINavigationController,
			let productDataViewController = navigationController.topViewController as? ProductDataViewController
			else {
				return
		}

		productDataViewController.title = (product == nil) ? NSLocalizedString("Add a Product", comment: "Screen title") : NSLocalizedString("Edit the Product", comment: "Screen title")
		productDataViewController.product = product
		productDataViewController.priceListViewModel = viewModel

		presenter.present(navigationController, animated: true) {
			
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		nameInputView.returnKeyType = .next
		nameInputView.type = .name

		priceInputView.returnKeyType = .send

		switch ShopManager.selectedShop?.tokenType ?? .eur {
		case .eur:
			priceInputView.type = .currency
		case .voucher:
			priceInputView.type = .integer
		}

		photoBackgroundView.addRoundedCorners()
		photoBackgroundView.addShadow()

		cameraIconView.tintColor = Theme.Color.lightText

		setup(product: self.product)
		
		containerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
	}

	private func setup(product: Product?) {
		guard nameInputView != nil
			else {
				return
		}
		nameInputView.text = product?.name
		if let price = product?.price {
			priceInputView.text = CurrencyFormatter.inputString(for: price)
		}
		productImage = product?.image
	}

	@IBAction func hideKeyboard(_ sender: Any? = nil) {
		nameInputView.resignFirstResponder()
		priceInputView.resignFirstResponder()
	}

	@IBAction func close(_ sender: Any? = nil) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func save(_ sender: Any? = nil) {
		nameInputView.validate()
		priceInputView.validate()

		guard let nameInput = nameInputView.validatedText,
		let priceInput = priceInputView.validatedText,
		let price = CurrencyFormatter.amount(for: priceInput)
			else {
				return
		}

		nameInputView.resignFirstResponder()
		priceInputView.resignFirstResponder()

		if let product = product {
			update(product: product, name: nameInput, price: price, image: productImage)
		}
		else {
			createProduct(named: nameInput, price: price, image: productImage)
		}
	}

	private func update(product: Product, name: String, price: Int, image: UIImage?) {
		guard let priceListViewModel = priceListViewModel
			else {
				return
		}

		showActivityIndicator()

		priceListViewModel.saveModified(product: product, name: name, price: price, image: image) { [weak self] (result) in
			switch result {
			case .success:
				self?.hideActivityIndicator()
			case .failure(let error):
				NotificationView.drop(error: error)
			}
			self?.close()
		}
	}

	private func createProduct(named name: String, price: Int, image: UIImage?) {
		guard let priceListViewModel = priceListViewModel
			else {
				return
		}

		showActivityIndicator()

		priceListViewModel.createNewProduct(named: name, price: price, image: image) { [weak self] (result) in
			switch result {
			case .success:
				self?.hideActivityIndicator()
			case .failure(let error):
				NotificationView.drop(error: error)
			}
			self?.close()
		}
	}

}

extension ProductDataViewController: TextInputDelegate {

	func inputFieldHitReturnKey(_ inputField: TextInputView) {
		switch inputField {
		case nameInputView:
			priceInputView.becomeFirstResponder()
		case priceInputView:
			priceInputView.resignFirstResponder()
			save()
		default:
			inputField.resignFirstResponder()
		}
	}

}

extension ProductDataViewController: UINavigationControllerDelegate {
	// Required for UIImagePickerController
}

extension ProductDataViewController {

	@IBAction func addPhoto(_ sender: Any? = nil) {
		let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: "Image source option"), style: .default) { [weak self] (action) in
			self?.presentImagePicker(source: .camera)
		}
		let libraryAction = UIAlertAction(title: NSLocalizedString("Photo Library", comment: "Image source option"), style: .default) { [weak self] (action) in
			self?.presentImagePicker(source: .photoLibrary)
		}
		let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in	}
		actionSheetController.addAction(cameraAction)
		actionSheetController.addAction(libraryAction)
		actionSheetController.addAction(cancelAction)
		present(actionSheetController, animated: true, completion: nil)
		actionSheetController.view.tintColor = Theme.Color.accent
	}

	private func presentImagePicker(source: UIImagePickerController.SourceType) {
		let permissionType: PrivacyPermissionType
		switch source {
		case .camera:
			permissionType = .camera
		case .photoLibrary:
			permissionType = .photoLibrary
		default:
			return
		}

		PrivacyPermissionsManager.getPermission(for: permissionType) { [weak self] (type, isGranted) in
			guard let strongSelf = self
				else {
					return
			}

			if isGranted {
				let imagePickerController = UIImagePickerController()
				imagePickerController.sourceType = source
				imagePickerController.allowsEditing = true
				imagePickerController.delegate = strongSelf

				strongSelf.present(imagePickerController, animated: true)
			}
			else {
				PrivacyPermissionsManager.presentSettingsAlert(for: type, in: strongSelf)
			}
		}
	}

}

extension ProductDataViewController: UIImagePickerControllerDelegate {

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true)

		guard let image = info[.editedImage] as? UIImage
			else {
				return
		}

		productImage = image.resized(to: Constants.Content.productImageSize)
	}

}

