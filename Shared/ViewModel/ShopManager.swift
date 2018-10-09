//
//  ShopManager.swift
//  Vallet
//
//  Created by Matija Kregar on 13/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import web3swift
import CoreData

class ShopManager {

	private static var shared = ShopManager()

	// The tokenFactory object is only needed for the ValletAdmin target
	private var _tokenFactory: TokenFactory?
	private var _selectedShop: Shop?
	private var _managedObjectContext: NSManagedObjectContext

	static var selectedShop: Shop? {
		get {
			if let shop = shared._selectedShop {
				return shop
			}
			shared._selectedShop = retrieveSelectedShop()
			return shared._selectedShop
		}
		set {
			UserDefaultsManager.selectedShopAddress = newValue?.address
			shared._selectedShop = newValue
			savedBalance = nil
		}
	}

	static var savedBalance: Int64?

	static var tokenFactory: TokenFactory? {
		return shared._tokenFactory
	}

	static var shops: [Shop] {
		// return shops from the database
		guard let shops = (try? shared._managedObjectContext.fetch(Shop.fetchRequest())) as? [Shop]
		else {
			return [Shop]()
		}
		return shops
	}

	init() {
		if let tokenFactoryAddress = EthereumAddress(Constants.BlockChain.tokenFactoryContractAddress) {
			self._tokenFactory = TokenFactory(address: tokenFactoryAddress)
		}
		self._managedObjectContext = DataBaseManager.managedContext
	}

	static var managedObjectContext: NSManagedObjectContext {
		set {
			shared._managedObjectContext = newValue
		}
		get {
			return shared._managedObjectContext
		}
	}

	static private func retrieveSelectedShop() -> Shop? {
		if let selectedShopAddress = UserDefaultsManager.selectedShopAddress,
			let selectedShop = shops.filter({ $0.address == selectedShopAddress }).first {
			return selectedShop
		}
		else if let shop = shops.first {
			UserDefaultsManager.selectedShopAddress = shop.address
			return shop
		}
		return nil
	}

	// MARK: - Total Supply/Ballance

	private static func token(for shop: Shop?) -> Token? {
		guard let shop = shop ?? selectedShop,
			let shopAddress = shop.address,
			let shopEthereumAddress = EthereumAddress(shopAddress)
			else {
				return nil
		}
		let token = Token(address: shopEthereumAddress)
		return token
	}

	static func totalSupply(for shop: Shop? = nil, completion: @escaping (Result<Int64>) -> Void) {
		guard let shop = shop ?? selectedShop,
			let token = token(for: shop)
			else {
				completion(Result.failure(ValletError.unwrapping(property: "shop", object: "ShopManager", function: #function)))
				return
		}
		token.totalSupply { (result) in
			completion(result)
		}
	}

	static func balance(for address: EthereumAddress, in shop: Shop? = nil, completion: @escaping (Result<Int64>) -> Void) {
		guard let shop = shop ?? selectedShop,
			let token = token(for: shop)
			else {
				completion(Result.failure(ValletError.unwrapping(property: "shop", object: "ShopManager", function: #function)))
				return
		}
		token.balance(for: address) { (result) in
			if case .success(let balance) = result {
				self.savedBalance = balance
			}
			completion(result)
		}
	}

	// MARK: - Price List

	static func loadPriceList(for shop: Shop? = nil, completion: @escaping (Result<PriceList>) -> Void) {
		guard let shop = shop ?? selectedShop,
			let shopAddress = shop.address
			else {
				completion(Result.failure(ValletError.unwrapping(property: "shop", object: "ShopManager", function: #function)))
				return
		}

		NetworkManager.performDataRequest(request: NetworkRequest.getPriceList(address: shopAddress)) { (result) in
			switch result {
			case .success(let listJSONData):
				guard let listJSONData = listJSONData
					else {
						completion(Result.failure(ValletError.networkData(function: #function)))
						return
				}
				// Update if the price list for the shop already exists.
				if let priceList = shop.priceList,
					priceList.update(with: listJSONData) {
					completion(Result.success(priceList))
					return
				}
				// Create a new price list with the loaded data
				guard let managedContext = shop.managedObjectContext
					else {
						completion(Result.failure(ValletError.unwrapping(property: "managedObjectContext", object: "ShopManager", function: #function)))
						return
				}
				do {
					let loadedPriceList = try PriceList.create(in: managedContext, jsonData: listJSONData)
					completion(Result.success(loadedPriceList))
				}
				catch {
					completion(Result.failure(error))
				}
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

}
