//
//  ValletError.swift
//  Vallet
//
//  Created by Matija Kregar on 08/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

enum ValletError: Error {

	case unwrapping(property: String, object: String, function: String?)
	case networkData(function: String?)
	case dataDecoding(object: String, function: String?)
	case dataEncoding(object: String, function: String?)
	case nonexistingData(function: String?)
	case rawValueConversion(object: String, function: String?)
	case storeInsertion(object: String, function: String?)
	case wallet(object: String, function: String?)
	case insuficientFunds
	case qrCodeAddress(object: String)
	case passwordNotFound(function: String?)

}

extension ValletError {

	var localizedNotificationTitle: String {
		switch self {
		case .unwrapping:
			return NSLocalizedString("Unwrapping Error", comment: "Error notification title")
		case .networkData:
			return NSLocalizedString("Network Data Error", comment: "Error notification title")
		case .dataDecoding:
			return NSLocalizedString("Data Decoding Error", comment: "Error notification title")
		case .dataEncoding:
			return NSLocalizedString("Data Encoding Error", comment: "Error notification title")
		case .nonexistingData:
			return NSLocalizedString("No Data Error", comment: "Error notification title")
		case .rawValueConversion:
			return NSLocalizedString("Raw Value Error", comment: "Error notification title")
		case .storeInsertion:
			return NSLocalizedString("Store Insertion Error", comment: "Error notification title")
		case .wallet:
			return NSLocalizedString("Wallet Error", comment: "Error notification title")
		case .insuficientFunds:
			return NSLocalizedString("Insuficient Funds", comment: "Error notification title")
		case .qrCodeAddress:
			return NSLocalizedString("QR Code error", comment: "Error notification title")
		case .passwordNotFound:
			return NSLocalizedString("Password not found", comment: "Error notification title")
		}
	}

}

extension ValletError: LocalizedError {

	var errorDescription: String? {
		switch self {

		case .unwrapping(let object, let property, let function):
			let descriptionFormat = NSLocalizedString("Failed unwraping %@ in %@ (function: %@)", comment: "Error description")
			return String(format: descriptionFormat, object, property, function ?? "")

		case .networkData(let function):
			let descriptionFormat = NSLocalizedString("Failed to load requested data (function: %@)", comment: "Error description")
			return String(format: descriptionFormat, function ?? "")

		case .dataDecoding(let object, let function):
			let descriptionFormat = NSLocalizedString("Failed to decode %@ (function: %@)", comment: "Error description")
			return String(format: descriptionFormat, object, function ?? "")

		case .dataEncoding(let object, let function):
			let descriptionFormat = NSLocalizedString("Failed to encode %@ (function: %@)", comment: "Error description")
			return String(format: descriptionFormat, object, function ?? "")

		case .nonexistingData(let function):
			let descriptionFormat = NSLocalizedString("Nonexisting data (function: %@)", comment: "Error description")
			return String(format: descriptionFormat, function ?? "")

		case .rawValueConversion(let object, let function):
			let descriptionFormat = NSLocalizedString("Failed to convert raw value to %@ (function: %@)", comment: "Error description")
			return String(format: descriptionFormat, object, function ?? "")

		case .storeInsertion(let object, let function):
			let descriptionFormat = NSLocalizedString("Failed to insert %@ in managed object context (function: %@)", comment: "Error description")
			return String(format: descriptionFormat, object, function ?? "")

		case .wallet(let object, let function):
			let descriptionFormat = NSLocalizedString("Failed to get %@ to open wallet (function: %@)", comment: "Error description")
			return String(format: descriptionFormat, object, function ?? "")

		case .insuficientFunds:
			return NSLocalizedString("You don't have enough money to pay for this item.", comment: "Error description")

		case .qrCodeAddress(let object):
			let descriptionFormat = NSLocalizedString("Failed to resolve %@ address from QR code", comment: "Error description")
			return String(format: descriptionFormat, object)
			
		case .passwordNotFound(let function):
			let descriptionFormat = NSLocalizedString("Counldn't find the password to sign (function: %@)", comment: "Error description")
			return String(format: descriptionFormat, function ?? "")
		}
	}

}
