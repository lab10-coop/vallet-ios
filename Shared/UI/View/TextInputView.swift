//
//  TextInputView.swift
//  Vallet
//
//  Created by Matija Kregar on 14/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

public enum TextInputType {
	case text
	case name
	case email
	case currency
	case decimal
	case integer
	case phone
	case password
	case constrained(validator: (String?) -> Bool)
	case URL
}

protocol TextInputDelegate: AnyObject {

	func inputFieldDidChange(_ inputField: TextInputView)
	func inputFieldDidEndEditing(_ inputField: TextInputView)
	func inputFieldHitReturnKey(_ inputField: TextInputView)

}

extension TextInputDelegate {

	func inputFieldDidChange(_ inputField: TextInputView) { }
	func inputFieldDidEndEditing(_ inputField: TextInputView) { }
	func inputFieldHitReturnKey(_ inputField: TextInputView) { }

}

class TextInputView: NibLinkedView {

	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var valueTextField: UITextField!

	weak var delegate: TextInputDelegate?

	var maxCharacterCount: Int?

	@IBInspectable var title: String? {
		didSet {
			titleLabel.text = title
		}
	}

	@IBInspectable var text: String? {
		get {
			return valueTextField.text
		}
		set {
			valueTextField.text = newValue
		}
	}

	@IBInspectable var placeholder: String? {
		get {
			return valueTextField.placeholder
		}
		set {
			valueTextField.placeholder = newValue
		}
	}

	@IBInspectable var returnKeyType: UIReturnKeyType {
		get {
			return valueTextField.returnKeyType
		}
		set {
			valueTextField.returnKeyType = newValue
		}
	}

	@IBInspectable var isRequired: Bool = false

	var isValid: Bool {
		guard let validator = validator
			else {
				return true
		}
		return validator(valueTextField.text)
	}

	var validatedText: String? {
		return isValid ? text : nil
	}

	var type: TextInputType? {
		didSet {
			guard let type = type
				else { return }
			var keyboardType: UIKeyboardType = .default
			var autocapitalizationType: UITextAutocapitalizationType = .none
			var isSecureTextEntry = false

			validator = isRequired ? requiredValueValidator : nil

			switch type {
			case .URL:
				keyboardType = .URL
			case .email:
				keyboardType = .emailAddress
			case .integer:
				keyboardType = .numberPad
			case .currency:
				keyboardType = .decimalPad
			case .password:
				isSecureTextEntry = true
				keyboardType = .default
			case .text:
				keyboardType = .default
			case .name:
				keyboardType = .default
				autocapitalizationType = .words
			case .phone:
				keyboardType = .phonePad
			case .decimal:
				keyboardType = .decimalPad
			case let .constrained(constrainValidator):
				keyboardType = .default
				validator = constrainValidator
			}

			valueTextField.keyboardType = keyboardType
			valueTextField.autocapitalizationType = autocapitalizationType
			valueTextField.isSecureTextEntry = isSecureTextEntry
		}
	}

	private var validator: ((String?) -> Bool)?

	override func setup() {
		titleLabel.text = ""
		titleLabel.textColor = Theme.Color.accent
		valueTextField.placeholder = ""
		valueTextField.text = ""
		valueTextField.font = Theme.Font.inputFieldFont
		valueTextField.textColor = Theme.Color.darkText
		valueTextField.returnKeyType = .next

		addBottomBorder(1.0, color: Theme.Color.separator)
	}

	@IBAction func didTapTextInputView(_ sender: Any) {
		_ = becomeFirstResponder()
	}

	@IBAction func textFieldDidChange(_ textField: UITextField) {
		delegate?.inputFieldDidChange(self)
	}

	@discardableResult
	override func becomeFirstResponder() -> Bool {
		super.becomeFirstResponder()
		return valueTextField.becomeFirstResponder()
	}

	@discardableResult
	override func resignFirstResponder() -> Bool {
		super.resignFirstResponder()
		return valueTextField.resignFirstResponder()
	}

	// MARK: - Validators

	func validate() {
		titleLabel.textColor = isValid ? Theme.Color.accent : Theme.Color.error
	}

	private var requiredValueValidator: (String?) -> Bool = {
		!($0?.isEmpty ?? true)
	}

}

// MARK: - UITextFieldDelegate

extension TextInputView: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		delegate?.inputFieldHitReturnKey(self)
		return true
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		validate()
		delegate?.inputFieldDidEndEditing(self)
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		return true
	}

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if case .currency? = type {
			guard let decimalSeparator = Locale.current.decimalSeparator,
			let text = textField.text
				else {
					return true
			}
			let newText = (text as NSString).replacingCharacters(in: range, with: string)
			let split = newText.components(separatedBy: decimalSeparator)
			
			// Allow only one decimal separator.
			if split.count > 2 {
				return false
			}
			// Limit the number of decimals.
			if split.count == 2 {
				return split.last?.count ?? 0 <= Constants.Content.maxCurrencyDecimals
			}
			return true
		}

		// maxCharacterCount limit
		guard let text = textField.text,
			let maxCharacterCount = maxCharacterCount
			else {
				return true
		}

		let newCount = text.count + string.count - range.length
		return newCount <= maxCharacterCount
	}

}
