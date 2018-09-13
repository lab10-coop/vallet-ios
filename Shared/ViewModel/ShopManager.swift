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

	// The tokenFactory object is only needed for the ValletAdmin target
	var tokenFactory: TokenFactory?
	let managedObjectContext: NSManagedObjectContext

	var shops: [Shop] {
		// return shops from the database
		guard let shops = (try? managedObjectContext.fetch(Shop.fetchRequest())) as? [Shop]
		else {
			return [Shop]()
		}
		return shops
	}

	init(tokenFactoryAddress: EthereumAddress? = nil, managedObjectContext: NSManagedObjectContext) {
		if let tokenFactoryAddress = tokenFactoryAddress {
			self.tokenFactory = TokenFactory(address: tokenFactoryAddress)
		}
		self.managedObjectContext = managedObjectContext
	}

	// TODO: Move this method to the ValletAdmin target
	func reload(for shopOwnerAddress: EthereumAddress, completion: @escaping (Result<[Shop]>) -> Void) {
		guard let tokenFactory = tokenFactory
			else {
				completion(Result.failure(Web3Error.unknownError))
				return
		}

		tokenFactory.loadAllCreatedShops(for: shopOwnerAddress) { [weak self] (result) in
			guard let strongSelf = self
				else {
					completion(Result.failure(Web3Error.unknownError))
					return
			}
			switch result {
			case .success(let shopsIntermediate):
				let loadedShops = shopsIntermediate.compactMap { Shop(in: strongSelf.managedObjectContext, intermediate: $0) }
				DataBaseManager.save(managedContext: strongSelf.managedObjectContext)
				completion(Result.success(loadedShops))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

}
