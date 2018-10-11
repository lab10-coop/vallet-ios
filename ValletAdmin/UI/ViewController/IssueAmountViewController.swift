//
//  IssueAmountViewController.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 17/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

protocol IssueViewControllerDelegate: class {

	func didIssueAmount(with pendingValueEvent: PendingValueEvent)

}

class IssueAmountViewController: UIViewController {

	@IBOutlet private var amountTextInputView: TextInputView!
	@IBOutlet private var issueButton: UIButton!

	var issueViewModel: IssueViewModel?

	weak var delegate: IssueViewControllerDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()

		issueButton.isEnabled = false

		amountTextInputView.delegate = self
		switch ShopManager.selectedShop?.tokenType ?? .eur {
			case .eur:
			amountTextInputView.type = .currency
			case .voucher:
			amountTextInputView.type = .integer
		}
	}

	@IBAction func issue(_ sender: Any? = nil) {
		_ = amountTextInputView.resignFirstResponder()

		guard let issueViewModel = issueViewModel
			else {
				return
		}
		
		showActivityIndicator()
		issueViewModel.issue { [weak self] (result) in
			switch result {
			case .success(let pendingEvent):
				self?.delegate?.didIssueAmount(with: pendingEvent)
				self?.dismiss(animated: true, completion: nil)
			case .failure(let error):
				NotificationView.drop(error: error)
			}
			self?.hideActivityIndicator()
		}
	}

}

extension IssueAmountViewController: TextInputDelegate {

	func inputFieldDidChange(_ inputField: TextInputView) {
		guard let issueViewModel = issueViewModel,
			let amountString = inputField.text,
			let amount = CurrencyFormatter.amount(for: amountString),
			amount > 0
			else {
				self.issueViewModel?.amount = 0
				issueButton.isEnabled = false
				return
		}

		issueViewModel.amount = amount
		issueButton.isEnabled = true
	}

	func inputFieldHitReturnKey(_ inputField: TextInputView) {
		guard let issueViewModel = issueViewModel,
			issueViewModel.amount > 0
			else {
				return
		}

		issue()
	}

}

