//
//  TokenFactory.swift
//  Vallet
//
//  Created by Matija Kregar on 06/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import web3swift
import PromiseKit
import BigInt

class TokenFactory: ContractProtocol {
	
	enum Method: String {
		case createTokenContract = "createTokenContract"
	}

	var jsonABI = "[{\"constant\": false,\"inputs\": [{\"name\": \"name\",\"type\": \"string\"},{\"name\": \"symbol\",\"type\": \"string\"},{\"name\": \"decimals\",\"type\": \"uint8\"}],\"name\": \"createTokenContract\",\"outputs\": [],\"payable\": false,\"stateMutability\": \"nonpayable\",\"type\": \"function\"},{\"anonymous\": false,\"inputs\": [{\"indexed\": false,\"name\": \"_address\",\"type\": \"address\"},{\"indexed\": false,\"name\": \"_creator\",\"type\": \"address\"},{\"indexed\": false,\"name\": \"_name\",\"type\": \"string\"},{\"indexed\": false,\"name\": \"_symbol\",\"type\": \"string\"},{\"indexed\": false,\"name\": \"_decimals\",\"type\": \"uint8\"}],\"name\": \"TokenCreated\",\"type\": \"event\"}]"


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

	func createShop(with address: EthereumAddress, name: String, type: TokenType, decimals: UInt = 12, completion: @escaping (Result<ShopIntermediate>) -> Void) {
		var options = Web3Options()
		options.from = address

		guard let intermediate = transactionIntermediate(method: Method.createTokenContract.rawValue, parameters: [NSString(string: name), NSString(string: type.rawValue), BigUInt(decimals) as AnyObject], options: options)
			else {
				completion(Result.failure(ValletError.unwrapping(property: "transactionIntermediate", object: "TokenFactory", function: #function)))
				return
		}

		intermediate.sendAsync(password: Constants.Temp.keystorePassword) { [weak self] (result) in
			switch result {
			case .success(let transactionSendingResult):
				guard let strongSelf = self
					else {
						completion(Result.failure(ValletError.unwrapping(property: "self", object: "TokenFactory", function: #function)))
						return
				}
				strongSelf.loadCreatedShop(from: transactionSendingResult) { (result) in
					switch result {
					case .success(let shop):
						completion(Result.success(shop))
					case .failure(let error):
						completion(Result.failure(error))
					}
				}
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	func loadAllCreatedShops(for address: EthereumAddress, completion: @escaping (Result<[ShopIntermediate]>) -> Void) {
		guard let contract = contract
			else {
				completion(Result.failure(ValletError.unwrapping(property: "contract", object: "TokenFactory", function: #function)))
				return
		}

		let eventFilter = EventFilter(fromBlock: .blockNumber(0), toBlock: .latest)

		DispatchQueue.global(qos: .background).async {
			let eventsResult = contract.getIndexedEvents(eventName: Constants.BlockChain.Event.tokenCreated, filter: eventFilter)

			DispatchQueue.main.async {
				switch eventsResult {
				case .success(let events):
					let myShops = events.compactMap { ShopIntermediate(decodedLog: $0.decodedResult) }.filter { $0.creatorAddress == address }
					completion(Result.success(myShops))
				case .failure(let error):
					print("Factory contract events error: \(error)")
					completion(Result.failure(error))
				}
			}
		}
	}

	private func loadCreatedShop(from transactionSendingResult: TransactionSendingResult, completion: @escaping (Result<ShopIntermediate>) -> Void) {
		Web3Manager.getTransactionReceipt(for: transactionSendingResult.hash) { [weak self] (receiptResult) in
			guard let strongSelf = self
				else {
					completion(Result.failure(ValletError.unwrapping(property: "self", object: "TokenFactory", function: #function)))
					return
			}
			switch receiptResult {
			case .success(let receipt):
				strongSelf.resolveShop(from: receipt, completion: { (result) in
					switch result {
					case .success(let shop):
						completion(Result.success(shop))
					case .failure(let error):
						completion(Result.failure(error))
					}
				})
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	private func resolveShop(from receipt: TransactionReceipt, completion: @escaping (Result<ShopIntermediate>) -> Void) {
		guard let contract = contract,
			let eventParser = contract.createEventParser(Constants.BlockChain.Event.tokenCreated, filter: nil)
			else {
				completion(Result.failure(ValletError.unwrapping(property: "contract, eventParser", object: "TokenFactory", function: #function)))
				return
		}

		DispatchQueue.global(qos: .background).async {
			let result = eventParser.parseTransactionByHash(receipt.transactionHash)
			
			DispatchQueue.main.async {
				switch result {
				case .success(let parsedEvents):
					guard let decodedResult = parsedEvents.first?.decodedResult,
						let shop = ShopIntermediate(decodedLog: decodedResult)
						else {
							completion(Result.failure(ValletError.dataDecoding(object: "ShopIntermediate", function: #function)))
							return
					}
					completion(Result.success(shop))
				case .failure(let error):
					print("factory events error: \(error)")
					completion(Result.failure(error))
				}
			}
		}
	}

}


struct ShopIntermediate: CustomStringConvertible {
	var name: String
	var symbol: TokenType
	var address: EthereumAddress
	var decimals: Int
	var creatorAddress: EthereumAddress

	init?(decodedLog: [String: Any]) {
		guard
			let newName = decodedLog["_name"] as? String,
			let newSymbolValue = decodedLog["_symbol"] as? String,
			let newSymbol = TokenType(rawValue: newSymbolValue),
			let newAddress = decodedLog["_address"] as? EthereumAddress,
			let decimalsValue = decodedLog["_decimals"],
			let newDecimals = Int("\(decimalsValue)"),
			let newCreatorAddress = decodedLog["_creator"] as? EthereumAddress
			else {
				return nil
		}

		self.name = newName
		self.symbol = newSymbol
		self.address = newAddress
		self.decimals = newDecimals
		self.creatorAddress = newCreatorAddress
	}

	var description: String {
		return "name: \(name), address: \(address.address)"
	}
}
