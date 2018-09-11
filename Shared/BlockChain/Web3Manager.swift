//
//  Web3Manager.swift
//  Vallet
//
//  Created by Matija Kregar on 06/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import web3swift

class Web3Manager {

	// MARK: - Instance

	private var _instance: web3?

	private static var shared = Web3Manager()

	static var instance: web3 {
		guard let instance = shared._instance
		else {
			fatalError("Call Web3Manager().start() before using it.")
		}
		return instance
	}

	private func createInstance() -> web3 {
		guard let nodeURL = URL(string: Constants.BlockChain.nodeAddress)
			else {
				fatalError("invalid node URL")
		}
		guard let createdInstance = Web3.new(nodeURL) else {
			fatalError("no instance created")
		}
		createdInstance.addKeystoreManager(Wallet.keystoreManager)
		return createdInstance
	}

	static func start() {
		shared._instance = shared.createInstance()
	}

	// MARK - Utils

	static func getTransactionReceipt(for txhash: String, completion: @escaping (Result<TransactionReceipt>) -> Void) {
		DispatchQueue.global(qos: .background).async {
			let result = Web3Manager.instance.eth.getTransactionReceipt(txhash)
			switch result {
			case .success(let receiptResult):
				completion(Result.success(receiptResult))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

}
