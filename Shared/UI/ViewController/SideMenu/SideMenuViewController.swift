//
//  SideMenuViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 11/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

protocol SideMenuDelegate: class {

	func didSelect(shop: Shop)

}

class SideMenuViewController: UIViewController {

	@IBOutlet private var logoImageView: UIImageView!
	@IBOutlet private var shopsTableView: UITableView!
	@IBOutlet private var createShopButton: UIButton!
	@IBOutlet private var containerView: UIView!
	@IBOutlet private var leftConstraint: NSLayoutConstraint!

	weak var delegate: SideMenuDelegate?

	static func present(over viewController: UIViewController) {
		let storyboard = UIStoryboard(name: "Shared", bundle: Bundle.main)
		guard let sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
			else {
				return
		}
		viewController.present(sideMenuViewController, animated: false) {
			sideMenuViewController.show()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		leftConstraint.constant = -containerView.bounds.size.width
		self.view.backgroundColor = .clear
	}

	func show() {
		leftConstraint.constant = 0
		UIView.animate(withDuration: Constants.Animation.shortDuration) {
			self.view.backgroundColor = UIColor(white: 0, alpha: 0.75)
			self.view.layoutIfNeeded()
		}
	}

	func hide() {
		leftConstraint.constant = -containerView.bounds.size.width
		UIView.animate(withDuration: Constants.Animation.shortDuration, animations: {
			self.view.backgroundColor = .clear
			self.view.layoutIfNeeded()
		}) { (success) in
			self.dismiss(animated: false, completion: nil)
		}
	}

	@IBAction func createShop(_ sender: UIButton) {
		print("create shop")
	}

	@IBAction func didTapBackgorund(_ sender: Any) {
		print("tap bg")
		hide()
	}

}

