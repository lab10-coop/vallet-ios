//
//  ShopManager+Client.swift
//  Vallet
//
//  Created by Matija Kregar on 18/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import CoreData
import web3swift

extension ShopManager {

	static func addShop(with address: String, completion: @escaping (Result<Shop>) -> Void) {
		guard let ethAddress = EthereumAddress(address)
			else {
				completion(Result.failure(ValletError.unwrapping(property: "ethAddress", object: "ShopManager", function: #function)))
				return
		}

		let token = Token(address: ethAddress)

		token.name { (nameResult) in
			switch nameResult {
			case .success(let name):
				token.symbol { (symbolResult) in
					switch symbolResult {
					case .success(let symbolValue):
						guard let symbol = TokenType(rawValue: symbolValue)
							else {
								completion(Result.failure(ValletError.rawValueConversion(object: "TokenType", function: #function)))
								return
						}
						token.creatorAddress { (creatorResult) in
							switch creatorResult {
							case .success(let creatorAddress):
								guard let shop = Shop(in: managedObjectContext, name: name, address: address, symbol: symbol, creatorAddress: creatorAddress)
									else {
										completion(Result.failure(ValletError.storeInsertion(object: "Shop", function: #function)))
										return
								}
								DataBaseManager.save(managedContext: managedObjectContext)
								completion(Result.success(shop))
							case .failure(let error):
								completion(Result.failure(error))
							}
						}
					case .failure(let error):
						completion(Result.failure(error))
					}
				}
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

}
