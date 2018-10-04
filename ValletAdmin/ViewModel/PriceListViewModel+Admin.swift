//
//  PriceListViewModel+Admin.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import UIKit

extension PriceListViewModel {

	func createNewProduct(named name: String, price: Int, image: UIImage?, completion: @escaping (Result<Bool>) -> Void) {
		if let image = image {
			IPFSManager.upload(image: image) { [weak self] (hashResult) in
				switch hashResult {
				case .success(let imagePath):
					self?.createNewProduct(named: name, price: price, imagePath: imagePath, image: image, completion: completion)
				case .failure(let error):
					completion(Result.failure(error))
				}
			}
		}
		else {
			createNewProduct(named: name, price: price, imagePath: nil, image: nil,  completion: completion)
		}
	}

	private func createNewProduct(named name: String, price: Int, imagePath: String?, image: UIImage?, completion: @escaping (Result<Bool>) -> Void) {
		guard let managedObjectContext = managedObjectContext,
			let product = Product(in: managedObjectContext, name: name, price: Int64(price), imagePath: imagePath, nfcTagId: nil, image: image)
			else {
				// TODO: Send an error to the completion block.
				return
		}

		ShopManager.add(product: product, to: shop)
		ShopManager.updatePriceList(for: shop) { (result) in
			completion(result)
		}

		updateProducts(to: shop.priceList)
		newDataBlock()
	}

}
