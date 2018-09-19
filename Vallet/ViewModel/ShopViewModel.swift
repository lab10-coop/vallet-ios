//
//  ShopViewModel.swift
//  Vallet
//
//  Created by Matija Kregar on 19/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import web3swift

class ShopViewModel {

	var token: Token
	var shop: Shop

	var clientAddress: String?

	lazy var managedObjectContext = { DataBaseManager.managedContext }()

	init?(with shop: Shop) {
		guard	let shopAddressValue = shop.address,
			let shopAddress = EthereumAddress(shopAddressValue)
			else {
				return nil
		}
		self.shop = shop
		self.token = Token(address: shopAddress)
		self.clientAddress = Wallet.address.address
	}

	func redeem(amount: Int, completion: @escaping (Result<Bool>) -> Void) {
		// TODO: Check if pendingEvent creates a retain cycle
		guard	amount > 0,
			let clientAddress = clientAddress,
			let clientEthAddress = EthereumAddress(clientAddress),
			let pendingEvent = PendingValueEvent(in: managedObjectContext, shop: shop, type: .redeem, value: Int64(amount), clientAddress: clientAddress, date: Date())
			else {
				completion(Result.failure(Web3Error.unknownError))
				return
		}

		DataBaseManager.save(managedContext: managedObjectContext)

		token.redeem(value: amount, from: clientEthAddress) { [weak self] (result) in
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
				completion(Result.success(success))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

}


