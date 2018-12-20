//
//  PriceListViewModel+Client.swift
//  Vallet
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

extension PriceListViewModel {

	func pay(for product: Product, completion: @escaping (Result<PendingValueEvent>) -> Void) {
		let clientAddress = Wallet.address.address
		let clientEthAddress = Wallet.address

		guard let managedObjectContext = managedObjectContext,
			product.price >= 0
			else {
				completion(Result.failure(ValletError.unwrapping(property: "managedObjectContext", object: "PriceListViewModel", function: #function)))
				return
		}

		token.redeem(value: Int(product.price), from: clientEthAddress) { [weak self] (result) in
			switch result {
			case .success(let transactionSendingResult):
				guard let strongSelf = self,
					let pendingEvent = PendingValueEvent(in: managedObjectContext, shop: strongSelf.shop, type: .redeem, value: product.price, productName: product.name, clientAddress: clientAddress, date: Date(), transactionHash: transactionSendingResult.hash)
					else {
						completion(Result.failure(ValletError.storeInsertion(object: "PendingValueEvent", function: #function)))
						return
				}
				DataBaseManager.save(managedContext: strongSelf.managedObjectContext)
				completion(Result.success(pendingEvent))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	func makeValueEvent(from pendingValueEvent: PendingValueEvent, completion: @escaping (Result<Bool>) -> Void) {
		PendingEventManager.makeValueEvent(from: pendingValueEvent) { (result) in
			completion(result)
		}
	}

}
