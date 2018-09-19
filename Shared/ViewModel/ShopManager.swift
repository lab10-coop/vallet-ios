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
		}
	}

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

}
