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
				completion(Result.failure(Web3Error.unknownError))
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
				completion(Result.failure(Web3Error.unknownError))
				return
		}

		tokenFactory.createShop(with: Wallet.address, name: name, type: .voucher) { (result) in
			switch result {
			case .success(let createdShop):
				guard let shop = Shop(in: managedObjectContext, intermediate: createdShop)
					else {
						completion(Result.failure(Web3Error.dataError))
						return
				}
				DataBaseManager.save(managedContext: managedObjectContext)
				completion(Result.success(shop))
			case .failure(let error):
				print(error)
			}
		}
	}
	
}
