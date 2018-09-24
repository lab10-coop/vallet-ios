//
//  PriceListViewModel+Client.swift
//  Vallet
//
//  Created by Matija Kregar on 24/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import web3swift

extension PriceListViewModel {

	func pay(for product: Product, completion: @escaping (Result<Bool>) -> Void) {
		// TODO: Check if pendingEvent creates a retain cycle
		let clientAddress = Wallet.address.address
		let clientEthAddress = Wallet.address

		guard let managedObjectContext = managedObjectContext,
			product.price > 0,
			let pendingEvent = PendingValueEvent(in: managedObjectContext, shop: shop, type: .redeem, value: product.price, clientAddress: clientAddress, date: Date())
			else {
				completion(Result.failure(Web3Error.unknownError))
				return
		}

		DataBaseManager.save(managedContext: managedObjectContext)

		token.redeem(value: Int(product.price), from: clientEthAddress) { [weak self] (result) in
			switch result {
			case .success(let receipt):
				let success = receipt.status == .ok
				guard let strongSelf = self,
					let _ = ValueEvent(from: pendingEvent, transactionHash: receipt.transactionHash, blockHash: receipt.blockHash, status: ValueEventStatus(from: receipt.status))
					else {
						completion(Result.failure(Web3Error.dataError))
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
