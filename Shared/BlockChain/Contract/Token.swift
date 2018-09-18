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

	// MARK: - Contract methods

	func issue(value: Int, to toAddress: EthereumAddress, from fromAddress: EthereumAddress, completion: @escaping (Result<TransactionReceipt>) -> Void) {
		var options = Web3Options()
		options.from = fromAddress

		guard let intermediate = transactionIntermediate(method: Method.issue.rawValue, parameters: [NSString(string: toAddress.address), BigUInt(value) as AnyObject], options: options)
			else {
				completion(Result.failure(Web3Error.unknownError))
				return
		}

		intermediate.sendAsync(password: Constants.Temp.keystorePassword) { (result) in
			switch result {
			case .success(let transactionResult):
				Web3Manager.getTransactionReceipt(for: transactionResult.hash, completion: { (receiptResult) in
					completion(receiptResult)
				})
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	func balance(of address: EthereumAddress, completion: @escaping (Result<Int>) -> Void) {
		guard let intermediate = transactionIntermediate(method: Method.balance.rawValue, parameters: [NSString(string: address.address)])
			else {
				completion(Result.failure(Web3Error.unknownError))
				return
		}

		intermediate.callAsync { (result) in
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
	}

	func redeem(value: Int, from address: EthereumAddress, completion: @escaping (Result<TransactionSendingResult>) -> Void) {
		var options = Web3Options()
		options.from = address

		guard let intermediate = transactionIntermediate(method: Method.redeem.rawValue, parameters: [BigUInt(value) as AnyObject], options: options)
			else {
				completion(Result.failure(Web3Error.unknownError))
				return
		}

		intermediate.sendAsync(password: Constants.Temp.keystorePassword) { (result) in
			completion(result)
		}
	}

	// MARK: - Properties

	func name(completion: @escaping (Result<String>) -> Void) {
		guard let intermediate = transactionIntermediate(method: Method.name.rawValue)
			else {
				completion(Result.failure(Web3Error.unknownError))
				return
		}

		intermediate.callAsync(options: nil) { result in
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
	}

	func totalSupply(completion: @escaping (Result<Int>) -> Void) {
		guard let intermediate = transactionIntermediate(method: Method.totalSupply.rawValue)
			else {
				completion(Result.failure(Web3Error.unknownError))
				return
		}

		intermediate.callAsync(options: nil) { result in
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

	func creatorAddress(completion: @escaping (Result<String>) -> Void) {
		guard let intermediate = transactionIntermediate(method: Method.creatorAddress.rawValue)
			else {
				completion(Result.failure(Web3Error.unknownError))
				return
		}

		intermediate.callAsync(options: nil) { result in
			switch result {
			case .success(let resultDictionary):
				guard let ethAddress = resultDictionary.first?.value as? EthereumAddress
					else {
						completion(Result.failure(Web3Error.dataError))
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
				completion(Result.failure(Web3Error.unknownError))
				return
		}

		intermediate.callAsync(options: nil) { result in
			switch result {
			case .success(let resultDictionary):
				guard let symbol = resultDictionary.first?.value as? String
					else {
						completion(Result.failure(Web3Error.dataError))
						return
				}
				completion(Result.success(symbol))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	// MARK: - Events

	func loadRedeemEvents(for clientAddress: EthereumAddress? = nil, completion: @escaping (Result<[EventValuable]?>) -> Void) {
		guard let contract = contract,
			let contractAddress = address
			else {
				completion(Result.failure(Web3Error.unknownError))
				return
		}

		let eventFilter = EventFilter(fromBlock: .blockNumber(0), toBlock: .latest, addresses: [contractAddress])

		DispatchQueue.global(qos: .background).async {
			let eventsResult = contract.getIndexedEvents(eventName: Constants.BlockChain.Event.redeem, filter: eventFilter, joinWithReceipts: true)

			switch eventsResult {
			case .success(let events):
				let redeems = events.compactMap { RedeemEvent(parserResult: $0) }.filter {
					guard let clientAddress = clientAddress
						else {
							return true
					}
					return $0.fromAddress == clientAddress
				}
				completion(Result.success(redeems))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	func loadTransferEvents(for clientAddress: EthereumAddress? = nil, completion: @escaping (Result<[EventValuable]?>) -> Void) {
		guard let contract = contract,
			let contractAddress = address
			else {
				completion(Result.failure(Web3Error.unknownError))
				return
		}

		let eventFilter = EventFilter(fromBlock: .blockNumber(0), toBlock: .latest, addresses: [contractAddress])

		DispatchQueue.global(qos: .background).async {
			let eventsResult = contract.getIndexedEvents(eventName: Constants.BlockChain.Event.transfer, filter: eventFilter, joinWithReceipts: true)

			switch eventsResult {
			case .success(let events):
				let transfers = events.compactMap { TransferEvent(parserResult: $0) }.filter {
					guard let clientAddress = clientAddress
						else {
							return true
					}
					return $0.toAddress == clientAddress
				}
				completion(Result.success(transfers))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	func loadHistory(for clientAddress: EthereumAddress? = nil, completion: @escaping (Result<[EventValuable]?>) -> Void) {
		var events = [EventValuable]()
		// TODO: investigate the retain cycle in this case
		loadTransferEvents(for: clientAddress) { (transferResult) in
			switch transferResult {
			case .success(let transfers):
				if let transfers = transfers {
					events.append(contentsOf: transfers)
				}
				self.loadRedeemEvents(for: clientAddress, completion: { (redeemResult) in
					switch redeemResult {
					case .success(let redeems):
						if let redeems = redeems {
							events.append(contentsOf: redeems)
						}
						events.sort(by: { $0.receipt.blockNumber < $1.receipt.blockNumber })
						completion(Result.success(events))
					case .failure:
						completion(redeemResult)
					}
				})
			case .failure:
				completion(transferResult)
			}
		}
	}

}

// TODO: move the events to separate files
protocol EventValuable: CustomStringConvertible {
	var value: Int { get }
	var receipt: TransactionReceipt { get }
}

struct TransferEvent: EventValuable {
	var value: Int
	var toAddress: EthereumAddress
	var receipt: TransactionReceipt

	init?(parserResult: EventParserResultProtocol) {
		guard let parsedValueString = parserResult.decodedResult["_value"],
			let parsedValue = Int("\(parsedValueString)"),
			let parsedAddress = parserResult.decodedResult["_to"] as? EthereumAddress,
			let transactionReceipt = parserResult.transactionReceipt
			else {
				return nil
		}
		self.value = parsedValue
		self.toAddress = parsedAddress
		self.receipt = transactionReceipt
	}

	var description: String {
		return "received: \(value), to: \(toAddress.address), blockNumber: \(receipt.blockNumber)"
	}
}

struct RedeemEvent: EventValuable {
	var value: Int
	var fromAddress: EthereumAddress
	var receipt: TransactionReceipt

	init?(parserResult: EventParserResultProtocol) {
		guard let parsedValueString = parserResult.decodedResult["_value"],
			let parsedValue = Int("\(parsedValueString)"),
			let parsedAddress = parserResult.decodedResult["_from"] as? EthereumAddress,
			let transactionReceipt = parserResult.transactionReceipt
			else {
				return nil
		}
		self.value = parsedValue
		self.fromAddress = parsedAddress
		self.receipt = transactionReceipt
	}

	var description: String {
		return "redeemed: \(value), from: \(fromAddress.address), blockNumber: \(receipt.blockNumber)"
	}
}
