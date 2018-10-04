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

	func saveModified(product: Product, name: String, price: Int, image: UIImage?, completion: @escaping (Result<Bool>) -> Void) {
		guard let managedObjectContext = product.managedObjectContext
			else {
				return
		}

		product.price = Int64(price)
		product.name = name

		if let image = image {
			IPFSManager.upload(image: image) { [weak self] (hashResult) in
				switch hashResult {
				case .success(let imagePath):
					product.imagePath = imagePath
					product.externalImage = ExternalImage(in: managedObjectContext, image: image, path: imagePath)
					self?.updatePricelist(completion: completion)
					DataBaseManager.save(managedContext: managedObjectContext)
				case .failure(let error):
					completion(Result.failure(error))
				}
			}
		}
		else {
			updatePricelist(completion: completion)
		}
	}

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
		updatePricelist(completion: completion)
	}

	// Uploades latest pricelist data to the API endpoint
	private func updatePricelist(completion: @escaping (Result<Bool>) -> Void) {
		ShopManager.updatePriceList(for: shop) { (result) in
			completion(result)
		}

		updateProducts(to: shop.priceList)
		newDataBlock()
	}

}
