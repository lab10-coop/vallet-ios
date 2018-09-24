//
//  PriceListViewModel+Admin.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

extension PriceListViewModel {

	func createNewProduct(named name: String, price: Int, completion: @escaping (Result<Bool>) -> Void) {
		guard let shop = shop,
			let managedObjectContext = shop.managedObjectContext,
			let product = Product(in: managedObjectContext, name: name, price: Int64(price), imagePath: nil, nfcTagId: nil)
			else {
				// TODO: Send an error to the completion block.
				return
		}

		ShopManager.add(product: product, to: shop)
		ShopManager.updatePriceList(for: shop) { (result) in
			completion(result)
		}
	}

}
