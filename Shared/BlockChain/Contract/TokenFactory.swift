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

	func createShop(with address: EthereumAddress, name: String, type: TokenType, decimals: UInt = 12, completion: @escaping (Result<Shop>) -> Void) {
		guard let contract = contract
			else {
				return
		}

		var options = Web3Options()
		options.from = address
		options.value = BigUInt(0)
		options.gasLimit = BigUInt(200000)

		guard let intermediate = contract.method(Method.createTokenContract.rawValue, parameters: [NSString(string: name), NSString(string: type.rawValue), BigUInt(decimals) as AnyObject], options: options)
			else {
				return
		}

		// TODO: Move off the main thread
		let result = intermediate.send(password: Constants.Temp.keystorePassword)

		switch result {
		case .success(let transactionSendingResult):
			loadCreatedShop(from: transactionSendingResult) { (result) in
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

	func loadAllCreatedShops(for address: EthereumAddress, completion: @escaping (Result<[Shop]?>) -> Void) {
		guard let contract = contract
			else {
				return
		}

		let eventFilter = EventFilter(fromBlock: .blockNumber(0), toBlock: .latest)

		// TODO: Move off the main thread
		let eventsResult = contract.getIndexedEvents(eventName: Constants.BlockChain.Event.tokenCreated, filter: eventFilter)

		switch eventsResult {
		case .success(let events):
			let myShops = events.compactMap { Shop(decodedLog: $0.decodedResult) }.filter { $0.creatorAddress == address }
			completion(Result.success(myShops))
		case .failure(let error):
			print("factory contract events error: \(error)")
			completion(Result.failure(error))
		}
	}

	// TODO: This is a general utility method ... find a better place to put it
	private func getTransactionReceipt(for txhash: String, completion: @escaping (Result<TransactionReceipt>) -> Void) {
		// TODO: Move off the main thread
		let result = Web3Manager.instance.eth.getTransactionReceipt(txhash)

		switch result {
		case .success(let receiptResult):
			completion(Result.success(receiptResult))
		case .failure(let error):
			completion(Result.failure(error))
		}
	}

	private func loadCreatedShop(from transactionSendingResult: TransactionSendingResult, completion: @escaping (Result<Shop>) -> Void) {
		var errorCount = 0
		// Use timer to get the transaction receipt, since it might not be ready immediately.
		Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] (timer) in
			self?.getTransactionReceipt(for: transactionSendingResult.hash, completion: { [weak self] (result) in
				switch result {
				case .success(let receipt):
					timer.invalidate()
					guard let shop = self?.resolveShop(from: receipt)
						else {
							completion(Result.failure(Web3Error.dataError))
							return
					}
					completion(Result.success(shop))
				case .failure(let error):
					errorCount += 1
					if errorCount > 30 {
						timer.invalidate()
						completion(Result.failure(error))
					}
					print("load transaction receipt error \(errorCount): \(error)")
				}
			})
		})
	}

	private func resolveShop(from receipt: TransactionReceipt) -> Shop? {
		guard let contract = contract,
			let eventParser = contract.createEventParser(Constants.BlockChain.Event.tokenCreated, filter: nil)
			else {
				return nil
		}

		// TODO: Move off the main thread
		let result = eventParser.parseTransactionByHash(receipt.transactionHash)

		switch result {
		case .success(let parsedEvents):
			if let decodedResult = parsedEvents.first?.decodedResult {
				return Shop(decodedLog: decodedResult)
			}
		case .failure(let error):
			print("factory events error: \(error)")
		}
		return nil
	}

}



struct Shop: CustomStringConvertible {
	var name: String
	var symbol: String
	var address: EthereumAddress
	var decimals: Int
	var creatorAddress: EthereumAddress

	init?(decodedLog: [String: Any]) {
		guard
			let newName = decodedLog["_name"] as? String,
			let newSymbol = decodedLog["_symbol"] as? String,
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
