//
//  PriceListViewModel+Client.swift
//  Vallet
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

extension PriceListViewModel {

	func pay(for product: Product, completion: @escaping (Result<Bool>) -> Void) {
		let clientAddress = Wallet.address.address
		let clientEthAddress = Wallet.address

		guard let managedObjectContext = managedObjectContext,
			product.price > 0,
			let pendingEvent = PendingValueEvent(in: managedObjectContext, shop: shop, type: .redeem, value: product.price, productName: product.name, clientAddress: clientAddress, date: Date())
			else {
				completion(Result.failure(ValletError.unwrapping(property: "pendingEvent", object: "PriceListViewModel", function: #function)))
				return
		}

		DataBaseManager.save(managedContext: managedObjectContext)

		token.redeem(value: Int(product.price), from: clientEthAddress) { [weak self] (result) in
			switch result {
			case .success(let receipt):
				let success = receipt.status == .ok
				guard let strongSelf = self,
					let _ = ValueEvent(from: pendingEvent, transactionHash: receipt.transactionHash, blockHash: receipt.blockHash, blockNumber: Int64(receipt.blockNumber), status: ValueEventStatus(from: receipt.status))
					else {
						completion(Result.failure(ValletError.storeInsertion(object: "ValueEvent", function: #function)))
						return
				}
				DataBaseManager.save(managedContext: strongSelf.managedObjectContext)
				NotificationCenter.default.post(name: Constants.Notification.newValueEvent, object: nil)
				completion(Result.success(success))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

}
