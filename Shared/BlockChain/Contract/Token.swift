//
//  Token.swift
//  Vallet
//
//  Created by Matija Kregar on 07/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import web3swift
import BigInt

class Token: ContractProtocol {

	enum Method: String {
		case issue = "issue"
		case balance = "balanceOf"
		case redeem = "redeem"
		case totalSupply = "totalSupply"
		case name = "name"
	}

	var jsonABI = "[{\"constant\": false, \"inputs\": [], \"name\": \"lockController\", \"outputs\": [], \"payable\": false, \"stateMutability\": \"nonpayable\", \"type\": \"function\" }, { \"constant\": true, \"inputs\": [], \"name\": \"name\", \"outputs\": [ { \"name\": \"\", \"type\": \"string\" } ], \"payable\": false, \"stateMutability\": \"view\", \"type\": \"function\" }, { \"constant\": false, \"inputs\": [ { \"name\": \"_spender\", \"type\": \"address\" }, { \"name\": \"_value\", \"type\": \"uint256\" } ], \"name\": \"approve\", \"outputs\": [ { \"name\": \"success\", \"type\": \"bool\" } ], \"payable\": false, \"stateMutability\": \"nonpayable\", \"type\": \"function\" }, { \"constant\": true, \"inputs\": [], \"name\": \"controllerLocked\", \"outputs\": [ { \"name\": \"\", \"type\": \"bool\" } ], \"payable\": false, \"stateMutability\": \"view\", \"type\": \"function\" }, { \"constant\": true, \"inputs\": [], \"name\": \"totalSupply\", \"outputs\": [ { \"name\": \"\", \"type\": \"uint256\" } ], \"payable\": false, \"stateMutability\": \"view\", \"type\": \"function\" }, { \"constant\": false, \"inputs\": [ { \"name\": \"_from\", \"type\": \"address\" }, { \"name\": \"_to\", \"type\": \"address\" }, { \"name\": \"_value\", \"type\": \"uint256\" } ], \"name\": \"transferFrom\", \"outputs\": [ { \"name\": \"success\", \"type\": \"bool\" } ], \"payable\": false, \"stateMutability\": \"nonpayable\", \"type\": \"function\" }, { \"constant\": true, \"inputs\": [], \"name\": \"decimals\", \"outputs\": [ { \"name\": \"\", \"type\": \"uint8\" } ], \"payable\": false, \"stateMutability\": \"view\", \"type\": \"function\" }, { \"constant\": true, \"inputs\": [], \"name\": \"version\", \"outputs\": [ { \"name\": \"\", \"type\": \"string\" } ], \"payable\": false, \"stateMutability\": \"view\", \"type\": \"function\" }, { \"constant\": true, \"inputs\": [], \"name\": \"getPriceListAddress\", \"outputs\": [ { \"name\": \"\", \"type\": \"bytes32\" } ], \"payable\": false, \"stateMutability\": \"view\", \"type\": \"function\" }, { \"constant\": false, \"inputs\": [ { \"name\": \"_token\", \"type\": \"address\" }, { \"name\": \"_to\", \"type\": \"address\" }, { \"name\": \"_amount\", \"type\": \"uint256\" } ], \"name\": \"withdrawTokens\", \"outputs\": [], \"payable\": false, \"stateMutability\": \"nonpayable\", \"type\": \"function\" }, { \"constant\": false, \"inputs\": [ { \"name\": \"addr\", \"type\": \"bytes32\" } ], \"name\": \"setPriceListAddress\", \"outputs\": [], \"payable\": false, \"stateMutability\": \"nonpayable\", \"type\": \"function\" }, { \"constant\": true, \"inputs\": [ { \"name\": \"_owner\", \"type\": \"address\" } ], \"name\": \"balanceOf\", \"outputs\": [ { \"name\": \"balance\", \"type\": \"uint256\" } ], \"payable\": false, \"stateMutability\": \"view\", \"type\": \"function\" }, { \"constant\": false, \"inputs\": [ { \"name\": \"_receiver\", \"type\": \"address\" }, { \"name\": \"_value\", \"type\": \"uint256\" } ], \"name\": \"issue\", \"outputs\": [], \"payable\": false, \"stateMutability\": \"nonpayable\", \"type\": \"function\" }, { \"constant\": false, \"inputs\": [ { \"name\": \"_newController\", \"type\": \"address\" } ], \"name\": \"setController\", \"outputs\": [], \"payable\": false, \"stateMutability\": \"nonpayable\", \"type\": \"function\" }, { \"constant\": true, \"inputs\": [], \"name\": \"symbol\", \"outputs\": [ { \"name\": \"\", \"type\": \"string\" } ], \"payable\": false, \"stateMutability\": \"view\", \"type\": \"function\" }, { \"constant\": false, \"inputs\": [ { \"name\": \"_to\", \"type\": \"address\" }, { \"name\": \"_value\", \"type\": \"uint256\" } ], \"name\": \"transfer\", \"outputs\": [ { \"name\": \"success\", \"type\": \"bool\" } ], \"payable\": false, \"stateMutability\": \"nonpayable\", \"type\": \"function\" }, { \"constant\": false, \"inputs\": [ { \"name\": \"_spender\", \"type\": \"address\" }, { \"name\": \"_value\", \"type\": \"uint256\" }, { \"name\": \"_extraData\", \"type\": \"bytes\" } ], \"name\": \"approveAndCall\", \"outputs\": [ { \"name\": \"success\", \"type\": \"bool\" } ], \"payable\": false, \"stateMutability\": \"nonpayable\", \"type\": \"function\" }, { \"constant\": false, \"inputs\": [ { \"name\": \"_value\", \"type\": \"uint256\" } ], \"name\": \"redeem\", \"outputs\": [ { \"name\": \"success\", \"type\": \"bool\" } ], \"payable\": false, \"stateMutability\": \"nonpayable\", \"type\": \"function\" }, { \"constant\": true, \"inputs\": [ { \"name\": \"_owner\", \"type\": \"address\" }, { \"name\": \"_spender\", \"type\": \"address\" } ], \"name\": \"allowance\", \"outputs\": [ { \"name\": \"remaining\", \"type\": \"uint256\" } ], \"payable\": false, \"stateMutability\": \"view\", \"type\": \"function\" }, { \"constant\": true, \"inputs\": [], \"name\": \"controller\", \"outputs\": [ { \"name\": \"\", \"type\": \"address\" } ], \"payable\": false, \"stateMutability\": \"view\", \"type\": \"function\" }, { \"inputs\": [ { \"name\": \"_controller\", \"type\": \"address\" }, { \"name\": \"_name\", \"type\": \"string\" }, { \"name\": \"_symbol\", \"type\": \"string\" }, { \"name\": \"_decimals\", \"type\": \"uint8\" } ], \"payable\": false, \"stateMutability\": \"nonpayable\", \"type\": \"constructor\" }, { \"anonymous\": false, \"inputs\": [ { \"indexed\": true, \"name\": \"_from\", \"type\": \"address\" }, { \"indexed\": true, \"name\": \"_to\", \"type\": \"address\" }, { \"indexed\": false, \"name\": \"_value\", \"type\": \"uint256\" } ], \"name\": \"Transfer\", \"type\": \"event\" }, { \"anonymous\": false, \"inputs\": [ { \"indexed\": true, \"name\": \"_from\", \"type\": \"address\" }, { \"indexed\": false, \"name\": \"_value\", \"type\": \"uint256\" } ], \"name\": \"Redeem\", \"type\": \"event\" }, { \"anonymous\": false, \"inputs\": [ { \"indexed\": true, \"name\": \"_owner\", \"type\": \"address\" }, { \"indexed\": true, \"name\": \"_spender\", \"type\": \"address\" }, { \"indexed\": false, \"name\": \"_value\", \"type\": \"uint256\" } ], \"name\": \"Approval\", \"type\": \"event\" }, { \"anonymous\": false, \"inputs\": [ { \"indexed\": true, \"name\": \"_address\", \"type\": \"bytes32\" } ], \"name\": \"PriceListUpdate\", \"type\": \"event\"}]"

	lazy var contract: web3.web3contract? = {
		guard let address = address
			else {
				return nil
		}
		let contract = Web3Manager.instance.contract(jsonABI, at: address, abiVersion: 2)
		return contract
	}()

	var address: EthereumAddress?

	init(address: EthereumAddress) {
		self.address = address
	}

	func issue(value: Int, to address: EthereumAddress, from fromAddress: EthereumAddress, completion: (Result<TransactionSendingResult>) -> Void) {
		guard let contract = contract
			else {
				return
		}

		var options = Web3Options()
		options.from = fromAddress
		options.value = BigUInt(0)
		options.gasLimit = BigUInt(200000)
		options.gasPrice = BigUInt(5000000000)

		guard let intermediate = contract.method(Method.issue.rawValue, parameters: [NSString(string: address.address), BigUInt(value) as AnyObject], options: options)
			else {
				return
		}

		// TODO: Move off the main thread
		let result = intermediate.send(password: Constants.Temp.keystorePassword)

		switch result {
		case .success(let transactionSendingResult):
			completion(Result.success(transactionSendingResult))
		case .failure(let error):
			completion(Result.failure(error))
		}
	}

	func balance(of address: EthereumAddress, completion: @escaping (Result<Int>) -> Void) {
		guard let contract = contract
			else {
				return
		}

		var options = Web3Options()
		options.value = BigUInt(0)
		options.gasLimit = BigUInt(200000)
		options.gasPrice = BigUInt(5000000000)

		guard let intermediate = contract.method(Method.balance.rawValue, parameters: [NSString(string: address.address)], options: options)
			else {
				return
		}

		let result = intermediate.call(options: nil)

		switch result {
		case .success(let resultDictionary):
			guard let balanceValue = resultDictionary["balance"],
				let balance = Int("\(balanceValue)")
				else {
					completion(Result.failure(Web3Error.dataError))
					return
			}
			completion(Result.success(balance))
		case .failure(let error):
			completion(Result.failure(error))
		}
	}

	func redeem(value: Int, from address: EthereumAddress, completion: @escaping (Result<TransactionSendingResult>) -> Void) {
		guard let contract = contract
			else {
				return
		}

		var options = Web3Options()
		options.from = address
		options.value = BigUInt(0)
		options.gasLimit = BigUInt(200000)
		options.gasPrice = BigUInt(5000000000)

		guard let intermediate = contract.method(Method.redeem.rawValue, parameters: [BigUInt(value) as AnyObject], options: options)
			else {
				return
		}

		// TODO: Move off the main thread
		let result = intermediate.send(password: Constants.Temp.keystorePassword)
		
		switch result {
		case .success(let transactionSendingResult):
			completion(Result.success(transactionSendingResult))
		case .failure(let error):
			completion(Result.failure(error))
		}
	}

	func name(completion: @escaping (Result<String>) -> Void) {
		guard let contract = contract
			else {
				return
		}

		var options = Web3Options()
		options.value = BigUInt(0)
		options.gasLimit = BigUInt(200000)
		options.gasPrice = BigUInt(5000000000)

		guard let intermediate = contract.method(Method.name.rawValue, parameters: [], options: options)
			else {
				return
		}

		let result = intermediate.call(options: nil)

		switch result {
		case .success(let resultDictionary):
			guard let name = resultDictionary.first?.value as? String
				else {
					completion(Result.failure(Web3Error.dataError))
					return
			}
			completion(Result.success(name))
		case .failure(let error):
			completion(Result.failure(error))
		}
	}

	func totalSupply(completion: @escaping (Result<Int>) -> Void) {
		guard let contract = contract
			else {
				return
		}

		var options = Web3Options()
		options.value = BigUInt(0)
		options.gasLimit = BigUInt(200000)
		options.gasPrice = BigUInt(5000000000)

		guard let intermediate = contract.method(Method.totalSupply.rawValue, parameters: [], options: options)
			else {
				return
		}

		let result = intermediate.call(options: nil)

		switch result {
		case .success(let resultDictionary):
			guard let supplyValue = resultDictionary.first?.value,
				let supply = Int("\(supplyValue)")
				else {
					completion(Result.failure(Web3Error.dataError))
					return
			}
			completion(Result.success(supply))
		case .failure(let error):
			completion(Result.failure(error))
		}
	}

}
