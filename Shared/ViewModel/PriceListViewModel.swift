//
//  PriceListViewModel.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

class PriceListViewModel {

	private(set) var shop: Shop?
	private(set) var priceList: PriceList? {
		didSet {
			updateProducts(to: priceList)
		}
	}

	var products: [Product]?

	var newDataBlock: (() -> Void) = {}

	init(shop: Shop) {
		self.shop = shop

		if let storedPriceList = shop.priceList {
			self.priceList = storedPriceList
		}
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
