//
//  ContractProtocol.swift
//  Vallet
//
//  Created by Matija Kregar on 06/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import web3swift
import BigInt

protocol ContractProtocol {

	var jsonABI: String { get }
	var contract: web3.web3contract? { get }
	var address: EthereumAddress? { get set }
	func transactionIntermediate(method: String, parameters: [AnyObject], options: Web3Options?) -> TransactionIntermediate?
	
}

extension ContractProtocol {

	func transactionIntermediate(method: String, parameters: [AnyObject] = [], options: Web3Options? = nil) -> TransactionIntermediate? {
		guard let contract = contract
			else {
				return nil
		}

		var defaultOptions = Web3Options()
		defaultOptions.value = BigUInt(0)
		defaultOptions.gasLimit = BigUInt(200000)
		defaultOptions.gasPrice = BigUInt(5000000000)

		let mergedOptions = Web3Options.merge(defaultOptions, with: options)

		guard let intermediate = contract.method(method, parameters: parameters, options: mergedOptions)
			else {
				return nil
		}

		return intermediate
	}

}

import enum Result.Result

extension TransactionIntermediate {

	func callAsync(options: Web3Options? = nil, onBlock: String = "latest", completion: @escaping (Result<[String: Any]>) -> Void) {
		DispatchQueue.global(qos: .background).async {
			let result = self.call(options: options, onBlock: onBlock)
			DispatchQueue.main.async {
				switch result {
				case .success(let value):
					completion(Result.success(value))
				case .failure(let error):
					completion(Result.failure(error))
				}
			}
		}
	}

	func sendAsync(password: String, options: Web3Options? = nil, onBlock: String = "pending", completion: @escaping (Result<TransactionSendingResult>) -> Void) {
		DispatchQueue.global(qos: .background).async {
			let result = self.send(password: password, options: options, onBlock: onBlock)
			DispatchQueue.main.async {
				switch result {
				case .success(let value):
					completion(Result.success(value))
				case .failure(let error):
					completion(Result.failure(error))
				}
			}
		}
	}

}
