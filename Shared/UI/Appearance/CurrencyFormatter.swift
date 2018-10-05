//
//  CurrencyFormatter.swift
//  Vallet
//
//  Created by Matija Kregar on 05/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

struct CurrencyFormatter {

	private static var decimalFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.locale = Locale.current
		return formatter
	}()

	private static var currencyFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.locale = Locale.current
		formatter.currencySymbol = "€"
		return formatter
	}()

	private static func centsFrom(input: String) -> Int? {
		guard let number = decimalFormatter.number(from: input)
			else {
				return nil
		}
		var cents = number.doubleValue * 100
		cents.round()
		return Int(cents)
	}

	private static func inputStringFrom(cents: Int) -> String? {
		return decimalFormatter.string(from: NSNumber(value: Double(cents)/100))
	}

	private static func currencyStringFrom(cents: Int) -> String? {
		return currencyFormatter.string(from: NSNumber(value: Double(cents)/100))
	}

	private static func currencyStringFrom(input: String) -> String? {
		guard let cents = centsFrom(input: input)
			else {
				return nil
		}
		return currencyStringFrom(cents: cents)
	}

	// MARK: - Amount conversion

	static func inputString(for amount: Int64, in shop: Shop? = nil) -> String? {
		guard let shop = shop ?? ShopManager.selectedShop,
			let tokenType = shop.tokenType
			else {
				return nil
		}
		switch tokenType  {
		case .voucher:
			return amount.description
		case .eur:
			return inputStringFrom(cents: Int(amount))
		}
	}

	static func displayString(for amount: Int64, in shop: Shop? = nil) -> String? {
		guard let shop = shop ?? ShopManager.selectedShop,
			let tokenType = shop.tokenType
			else {
				return nil
		}
		switch tokenType {
		case .voucher:
			return amount.description
		case .eur:
			return currencyStringFrom(cents: Int(amount))
		}
	}

	static func amount(for input: String, in shop: Shop? = nil) -> Int? {
		guard let shop = shop ?? ShopManager.selectedShop,
			let tokenType = shop.tokenType
			else {
				return nil
		}
		switch tokenType  {
		case .voucher:
			return Int(input)
		case .eur:
			return centsFrom(input: input)
		}
	}

}
