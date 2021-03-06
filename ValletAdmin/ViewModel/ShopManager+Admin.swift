//
//  ShopManager+Admin.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 18/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import web3swift

extension ShopManager {

	static func reload(for shopOwnerAddress: EthereumAddress, completion: @escaping (Result<[Shop]>) -> Void) {
		guard let tokenFactory = tokenFactory
			else {
				completion(Result.failure(ValletError.unwrapping(property: "tokenFactory", object: "ShopManager", function: #function)))
				return
		}

		tokenFactory.loadAllCreatedShops(for: shopOwnerAddress) { (result) in
			switch result {
			case .success(let shopsIntermediate):
				let loadedShops = shopsIntermediate.compactMap { Shop(in: managedObjectContext, intermediate: $0) }
				DataBaseManager.save(managedContext: managedObjectContext)
				completion(Result.success(loadedShops))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	static func createShop(named name: String, completion: @escaping (Result<Shop>) -> Void) {
		guard let tokenFactory = tokenFactory
			else {
				completion(Result.failure(ValletError.unwrapping(property: "tokenFactory", object: "ShopManager", function: #function)))
				return
		}

		tokenFactory.createShop(with: Wallet.address, name: name, type: .eur) { (result) in
			switch result {
			case .success(let createdShop):
				guard let shop = Shop(in: managedObjectContext, intermediate: createdShop)
					else {
						completion(Result.failure(ValletError.storeInsertion(object: "Shop", function: #function)))
						return
				}
				DataBaseManager.save(managedContext: managedObjectContext)
				createPriceList(for: shop, completion: { (listResult) in
					switch listResult {
					case .success(let priceList):
						guard let shop = priceList.shop
							else {
								completion(Result.failure(ValletError.unwrapping(property: "shop", object: "PriceList", function: #function)))
								return
						}
						uploadPriceList(for: shop, completion: { (uploadResult) in
							switch uploadResult {
							case .success:
								completion(Result.success(shop))
								DataBaseManager.save(managedContext: managedObjectContext)
							case .failure(let error):
								completion(Result.failure(error))
							}
						})
						
					case .failure(let error):
						completion(Result.failure(error))
					}
				})

			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	// MARK: - Price List

	private static func createPriceList(for shop: Shop? = nil, completion: (Result<PriceList>) -> Void) {
		guard let shop = shop ?? selectedShop,
			shop.address != nil,
			let blankPriceList = PriceList(in: managedObjectContext, shop: shop)
			else {
				completion(Result.failure(ValletError.unwrapping(property: "shop, priceList, jsonData", object: "ShopManager", function: #function)))
				return
		}
		
		completion(Result.success(blankPriceList))
	}

	static func uploadPriceList(for shop: Shop? = nil, completion: @escaping (Result<Bool>) -> Void) {
		guard let shop = shop ?? selectedShop,
			let priceList = shop.priceList,
			let jsonData = priceList.jsonData
			else {
				completion(Result.failure(ValletError.unwrapping(property: "shop, priceList, jsonData", object: "ShopManager", function: #function)))
				return
		}
		
		let shopToken = token(for: shop)
		
		IPFSManager.upload(data: jsonData) { (result) in
			switch result {
			case .success(let pricelistHash):
				let pricelistAddress = IPFSManager.hexEncode(hash: pricelistHash)
				
				shopToken?.setPricelist(address: pricelistAddress!, from: Wallet.address, completion: { (result) in
					switch result {
					case .success(let transaction):
						// TODO: Possibly implement waiting for the receipt.
						completion(Result.success(true))
					case .failure(let error):
						completion(Result.failure(error))
					}
				})
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	static func add(product: Product, to shop: Shop? = nil) {
		guard let shop = shop ?? selectedShop,
			let priceList = shop.priceList
			else {
				return
		}

		// Prevent from adding an item with the same name
		guard let products = priceList.products?.array as? [Product],
			products.filter({ $0.name == product.name }).first == nil
			else {
				return
		}

		priceList.addToProducts(product)
		DataBaseManager.save(managedContext: managedObjectContext)
	}

	static func remove(product: Product, from shop: Shop? = nil) {
		guard let shop = shop ?? selectedShop,
			let priceList = shop.priceList
			else {
				return
		}

		priceList.removeFromProducts(product)
		product.delete()
		DataBaseManager.save(managedContext: managedObjectContext)
	}
	
}
