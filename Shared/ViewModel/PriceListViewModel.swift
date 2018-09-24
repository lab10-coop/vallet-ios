//
//  PriceListViewModel.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import web3swift
import CoreData

class PriceListViewModel {

	private(set) var shop: Shop
	private(set) var token: Token
	private(set) var priceList: PriceList? {
		didSet {
			updateProducts(to: priceList)
		}
	}
	var managedObjectContext: NSManagedObjectContext? {
		return shop.managedObjectContext
	}

	var products: [Product]?

	var newDataBlock: (() -> Void) = {}

	init?(shop: Shop) {
		guard	let shopAddressValue = shop.address,
			let shopAddress = EthereumAddress(shopAddressValue)
			else {
				return nil
		}
		self.shop = shop
		self.token = Token(address: shopAddress)

		self.priceList = shop.priceList
	}

	func reload() {
		ShopManager.loadPriceList(for: shop) { (result) in
			switch result {
			case .success(let priceList):
				self.priceList = priceList
			case .failure(let error):
				print("Price list load error: \(error)")
			}
		}
	}

	func updateProducts(to priceList: PriceList?) {
		self.products = priceList?.products?.array as? [Product]
		newDataBlock()
	}

}
