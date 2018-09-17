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

	init?(with shop: Shop?) {
		guard let shop = shop ?? ShopManager.selectedShop,
			let shopAddressValue = shop.address,
			let shopAddress = EthereumAddress(shopAddressValue)
			else {
				return nil
		}

		self.token = Token(address: shopAddress)
	}

	func issue(completion: @escaping (Result<Bool>) -> Void) {
		guard	amount > 0,
			let clientAddress = clientAddress,
			let clientEthAddress = EthereumAddress(clientAddress)
			else {
				completion(Result.failure(Web3Error.unknownError))
				return
		}
		
		token.issue(value: amount, to: clientEthAddress, from: Wallet.address) { (result) in
			switch result {
			case .success(let receipt):
				let success = receipt.status == .ok
				completion(Result.success(success))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

}

