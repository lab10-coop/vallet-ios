//
//  IssueViewModel.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 17/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import web3swift

class IssueViewModel {

	var clientAddress: String?
	var	amount: Int = 0
	var token: Token
	var shop: Shop

	lazy var managedObjectContext = { DataBaseManager.managedContext }()

	init?(with shop: Shop) {
		guard	let shopAddressValue = shop.address,
			let shopAddress = EthereumAddress(shopAddressValue)
			else {
				return nil
		}
		self.shop = shop
		self.token = Token(address: shopAddress)
	}

	func issue(completion: @escaping (Result<Bool>) -> Void) {
		// TODO: Check if pendingEvent creates a retain cycle
		guard	amount > 0,
			let clientAddress = clientAddress,
			let clientEthAddress = EthereumAddress(clientAddress),
			let pendingEvent = PendingValueEvent(in: managedObjectContext, shop: shop, type: .issue, value: Int64(amount), clientAddress: clientAddress, date: Date())
			else {
				completion(Result.failure(Web3Error.unknownError))
				return
		}

		DataBaseManager.save(managedContext: managedObjectContext)
		
		token.issue(value: amount, to: clientEthAddress, from: Wallet.address) { [weak self] (result) in
			switch result {
			case .success(let receipt):
				let success = receipt.status == .ok
				guard let strongSelf = self,
					let _ = ValueEvent(from: pendingEvent, transactionHash: receipt.transactionHash, blockHash: receipt.blockHash, blockNumber: Int64(receipt.blockNumber), status: ValueEventStatus(from: receipt.status))
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

