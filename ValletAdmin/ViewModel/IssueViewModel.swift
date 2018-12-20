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

	func issue(completion: @escaping (Result<PendingValueEvent>) -> Void) {
		guard	self.amount >= 0,
			let clientAddress = clientAddress,
			let clientEthAddress = EthereumAddress(clientAddress)
			else {
				completion(Result.failure(ValletError.unwrapping(property: "clientEthAddress, pendingEvent", object: "IssueViewModel", function: #function)))
				return
		}

		let amount = self.amount
		
		token.issue(value: amount, to: clientEthAddress, from: Wallet.address) { [weak self] (result) in
			switch result {
			case .success(let transactionSendingResult):
				guard let strongSelf = self,
					let pendingEvent = PendingValueEvent(in: strongSelf.managedObjectContext, shop: strongSelf.shop, type: .issue, value: Int64(amount), clientAddress: clientAddress, date: Date(), transactionHash: transactionSendingResult.hash)
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

}

