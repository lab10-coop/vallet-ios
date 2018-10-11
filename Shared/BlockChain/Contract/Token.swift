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
		case creatorAddress = "controller"
		case symbol = "symbol"
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

	convenience init?(shop: Shop) {
		guard let shopAddressValue = shop.address,
			let shopAddress = EthereumAddress(shopAddressValue)
			else {
				return nil
		}
		self.init(address: shopAddress)
	}

	// MARK: - Contract methods

	func issue(value: Int, to toAddress: EthereumAddress, from fromAddress: EthereumAddress, completion: @escaping (Result<TransactionSendingResult>) -> Void) {
		var options = Web3Options()
		options.from = fromAddress

		guard let intermediate = transactionIntermediate(method: Method.issue.rawValue, parameters: [NSString(string: toAddress.address), BigUInt(value) as AnyObject], options: options)
			else {
				completion(Result.failure(ValletError.unwrapping(property: "transactionIntermediate", object: "Token", function: #function)))
				return
		}

		intermediate.sendAsync(password: Constants.Temp.keystorePassword) { (result) in
			switch result {
			case .success(let transactionResult):
				completion(Result.success(transactionResult))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	func balance(for address: EthereumAddress, completion: @escaping (Result<Int64>) -> Void) {
		guard let intermediate = transactionIntermediate(method: Method.balance.rawValue, parameters: [NSString(string: address.address)])
			else {
				completion(Result.failure(ValletError.unwrapping(property: "transactionIntermediate", object: "Token", function: #function)))
				return
		}

		intermediate.callAsync { (result) in
			switch result {
			case .success(let resultDictionary):
				guard let balanceValue = resultDictionary["balance"],
					let balance = Int64("\(balanceValue)")
					else {
						completion(Result.failure(ValletError.dataDecoding(object: "balance", function: #function)))
						return
				}
				completion(Result.success(balance))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	func redeem(value: Int, from address: EthereumAddress, completion: @escaping (Result<TransactionSendingResult>) -> Void) {
		var options = Web3Options()
		options.from = address

		guard let intermediate = transactionIntermediate(method: Method.redeem.rawValue, parameters: [BigUInt(value) as AnyObject], options: options)
			else {
				completion(Result.failure(ValletError.unwrapping(property: "transactionIntermediate", object: "Token", function: #function)))
				return
		}

		intermediate.sendAsync(password: Constants.Temp.keystorePassword) { (result) in
			switch result {
			case .success(let transactionResult):
				completion(Result.success(transactionResult))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	// MARK: - Properties

	func name(completion: @escaping (Result<String>) -> Void) {
		guard let intermediate = transactionIntermediate(method: Method.name.rawValue)
			else {
				completion(Result.failure(ValletError.unwrapping(property: "transactionIntermediate", object: "Token", function: #function)))
				return
		}

		intermediate.callAsync(options: nil) { result in
			switch result {
			case .success(let resultDictionary):
				guard let name = resultDictionary.first?.value as? String
					else {
						completion(Result.failure(ValletError.dataDecoding(object: "name", function: #function)))
						return
				}
				completion(Result.success(name))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	func totalSupply(completion: @escaping (Result<Int64>) -> Void) {
		guard let intermediate = transactionIntermediate(method: Method.totalSupply.rawValue)
			else {
				completion(Result.failure(ValletError.unwrapping(property: "transactionIntermediate", object: "Token", function: #function)))
				return
		}

		intermediate.callAsync(options: nil) { result in
			switch result {
			case .success(let resultDictionary):
				guard let supplyValue = resultDictionary.first?.value,
					let supply = Int64("\(supplyValue)")
					else {
						completion(Result.failure(ValletError.dataDecoding(object: "supply", function: #function)))
						return
				}
				completion(Result.success(supply))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	func creatorAddress(completion: @escaping (Result<String>) -> Void) {
		guard let intermediate = transactionIntermediate(method: Method.creatorAddress.rawValue)
			else {
				completion(Result.failure(ValletError.unwrapping(property: "transactionIntermediate", object: "Token", function: #function)))
				return
		}

		intermediate.callAsync(options: nil) { result in
			switch result {
			case .success(let resultDictionary):
				guard let ethAddress = resultDictionary.first?.value as? EthereumAddress
					else {
						completion(Result.failure(ValletError.dataDecoding(object: "ethAddress", function: #function)))
						return
				}
				completion(Result.success(ethAddress.address))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	func symbol(completion: @escaping (Result<String>) -> Void) {
		guard let intermediate = transactionIntermediate(method: Method.symbol.rawValue)
			else {
				completion(Result.failure(ValletError.unwrapping(property: "transactionIntermediate", object: "Token", function: #function)))
				return
		}

		intermediate.callAsync(options: nil) { result in
			switch result {
			case .success(let resultDictionary):
				guard let symbol = resultDictionary.first?.value as? String
					else {
						completion(Result.failure(ValletError.dataDecoding(object: "symbol", function: #function)))
						return
				}
				completion(Result.success(symbol))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	// MARK: - Events

	func loadRedeemEvents(for clientAddress: EthereumAddress? = nil, fromBlock: UInt64 = 0, completion: @escaping (Result<[ValueEventIntermediate]>) -> Void) {
		guard let contract = contract,
			let contractAddress = address
			else {
				completion(Result.failure(ValletError.unwrapping(property: "contract, address", object: "Token", function: #function)))
				return
		}

		var events = [ValueEventIntermediate]()
		let eventFilter = EventFilter(fromBlock: .blockNumber(fromBlock), toBlock: .latest, addresses: [contractAddress])

		DispatchQueue.global(qos: .background).async {
			let eventsResult = contract.getIndexedEvents(eventName: Constants.BlockChain.Event.redeem, filter: eventFilter, joinWithReceipts: true)

			DispatchQueue.main.async {
				switch eventsResult {
				case .success(let loadedEvents):
					let redeems = loadedEvents.compactMap { ValueEventIntermediate(redeemResult: $0) }.filter {
						guard let clientAddress = clientAddress
							else {
								return true
						}
						return $0.clientAddress == clientAddress
					}
					events.append(contentsOf: redeems)
					completion(Result.success(events))
				case .failure(let error):
					completion(Result.failure(error))
				}
			}
		}
	}

	func loadTransferEvents(for clientAddress: EthereumAddress? = nil, fromBlock: UInt64 = 0, completion: @escaping (Result<[ValueEventIntermediate]>) -> Void) {
		guard let contract = contract,
			let contractAddress = address
			else {
				completion(Result.failure(ValletError.unwrapping(property: "contract, address", object: "Token", function: #function)))
				return
		}

		var events = [ValueEventIntermediate]()
		let eventFilter = EventFilter(fromBlock: .blockNumber(fromBlock), toBlock: .latest, addresses: [contractAddress])

		DispatchQueue.global(qos: .background).async {
			let eventsResult = contract.getIndexedEvents(eventName: Constants.BlockChain.Event.transfer, filter: eventFilter, joinWithReceipts: true)

			DispatchQueue.main.async {
				switch eventsResult {
				case .success(let loadedEvents):
					let transfers = loadedEvents.compactMap { ValueEventIntermediate(issueResult: $0) }.filter {
						guard let clientAddress = clientAddress
							else {
								return true
						}
						return $0.clientAddress == clientAddress
					}
					events.append(contentsOf: transfers)
					completion(Result.success(events))
				case .failure(let error):
					completion(Result.failure(error))
				}
			}
		}
	}

	func loadHistory(for clientAddress: EthereumAddress? = nil, fromBlock: UInt64 = 0, completion: @escaping (Result<[ValueEventIntermediate]>) -> Void) {
		var events = [ValueEventIntermediate]()
		// TODO: investigate the retain cycle in this case
		loadTransferEvents(for: clientAddress, fromBlock: fromBlock) { (transferResult) in
			switch transferResult {
			case .success(let transfers):
				events.append(contentsOf: transfers)
				self.loadRedeemEvents(for: clientAddress, fromBlock: fromBlock) { (redeemResult) in
					switch redeemResult {
					case .success(let redeems):
						events.append(contentsOf: redeems)
						completion(Result.success(events))
					case .failure:
						completion(redeemResult)
					}
				}
			case .failure:
				completion(transferResult)
			}
		}
	}

}

struct ValueEventIntermediate: CustomStringConvertible {

	var transactionHash: String
	var value: Int64
	var clientAddress: EthereumAddress
	var type: ValueEventType
	var status: ValueEventStatus
	var blockHash: String
	var blockNumber: Int64
	var date: Date?

	init?(issueResult: EventParserResultProtocol) {
		guard let parsedValueString = issueResult.decodedResult["_value"],
			let parsedValue = Int64("\(parsedValueString)"),
			let parsedAddress = issueResult.decodedResult["_to"] as? EthereumAddress,
			let transactionReceipt = issueResult.transactionReceipt
			else {
				return nil
		}
		self.value = parsedValue
		self.clientAddress = parsedAddress
		self.type = .issue
		self.transactionHash = transactionReceipt.transactionHash.hashString
		self.blockHash = transactionReceipt.blockHash.hashString
		self.blockNumber = Int64(transactionReceipt.blockNumber)
		switch transactionReceipt.status {
		case .ok:
			self.status = .ok
		case .failed:
			self.status = .failed
		case .notYetProcessed:
			self.status = .unknown
		}
	}

	init?(redeemResult: EventParserResultProtocol) {
		guard let parsedValueString = redeemResult.decodedResult["_value"],
			let parsedValue = Int64("\(parsedValueString)"),
			let parsedAddress = redeemResult.decodedResult["_from"] as? EthereumAddress,
			let transactionReceipt = redeemResult.transactionReceipt
			else {
				return nil
		}
		self.value = parsedValue
		self.clientAddress = parsedAddress
		self.type = .redeem
		self.transactionHash = transactionReceipt.transactionHash.hashString
		self.blockHash = transactionReceipt.blockHash.hashString
		self.blockNumber = Int64(transactionReceipt.blockNumber)
		switch transactionReceipt.status {
		case .ok:
			self.status = .ok
		case .failed:
			self.status = .failed
		case .notYetProcessed:
			self.status = .unknown
		}
	}

	var description: String {
		return "\(type.rawValue): \(value), client: \(clientAddress.address)"
	}

}
