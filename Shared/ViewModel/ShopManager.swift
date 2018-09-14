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
	private var tokenFactory: TokenFactory?
	private var managedObjectContext: NSManagedObjectContext

	// TODO: find a way to persist selectedShop on the device
	static var selectedShop: Shop?

	static var shops: [Shop] {
		// return shops from the database
		guard let shops = (try? shared.managedObjectContext.fetch(Shop.fetchRequest())) as? [Shop]
		else {
			return [Shop]()
		}
		return shops
	}

	init() {
		if let tokenFactoryAddress = EthereumAddress(Constants.BlockChain.tokenFactoryContractAddress) {
			self.tokenFactory = TokenFactory(address: tokenFactoryAddress)
		}
		self.managedObjectContext = DataBaseManager.managedContext
	}

	static func setManagedObjectContext(_ value: NSManagedObjectContext) {
		shared.managedObjectContext = value
	}

	// TODO: Move this method to the ValletAdmin target
	static func reload(for shopOwnerAddress: EthereumAddress, completion: @escaping (Result<[Shop]>) -> Void) {
		guard let tokenFactory = shared.tokenFactory
			else {
				completion(Result.failure(Web3Error.unknownError))
				return
		}

		tokenFactory.loadAllCreatedShops(for: shopOwnerAddress) { (result) in
			switch result {
			case .success(let shopsIntermediate):
				let loadedShops = shopsIntermediate.compactMap { Shop(in: shared.managedObjectContext, intermediate: $0) }
				DataBaseManager.save(managedContext: shared.managedObjectContext)
				completion(Result.success(loadedShops))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	static func createShop(named name: String, completion: @escaping (Result<Shop>) -> Void) {
		guard let tokenFactory = shared.tokenFactory
			else {
				completion(Result.failure(Web3Error.unknownError))
				return
		}

		tokenFactory.createShop(with: Wallet.address, name: name, type: .voucher) { (result) in
			switch result {
			case .success(let createdShop):
				guard let shop = Shop(in: shared.managedObjectContext, intermediate: createdShop)
					else {
						completion(Result.failure(Web3Error.dataError))
						return
				}
				DataBaseManager.save(managedContext: shared.managedObjectContext)
				completion(Result.success(shop))
			case .failure(let error):
				print(error)
			}
		}
	}

}
