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
	private var timers = [Timer]()

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
		Wallet.start()
		shared._instance = shared.createInstance()
	}

	// MARK - Utils

	static func getTransactionReceipt(for txhash: String, completion: @escaping (Result<TransactionReceipt>) -> Void) {
		var repeatCount = 0
		// Use timer to get the transaction receipt, since it might not be ready immediately.
		let newTimer = Timer.scheduledTimer(withTimeInterval: Constants.Timer.pollInterval, repeats: true, block: { (timer) in
			print("Transaction receipt timer: \(repeatCount)")
			DispatchQueue.global(qos: .background).async {
				let result = Web3Manager.instance.eth.getTransactionReceipt(txhash)
				DispatchQueue.main.async {
					switch result {
					case .success(let receiptResult):
						timer.invalidate()
						completion(Result.success(receiptResult))
					case .failure(let error):
						repeatCount += 1
						if repeatCount > Constants.Timer.maxRepeatCount {
							timer.invalidate()
							remove(timer: timer)
							completion(Result.failure(error))
						}
						print("Load transaction receipt error \(repeatCount): \(error)")
					}
				}
			}
		})
		add(timer: newTimer)
	}

	static func getBlock(by blockHash: Data, completion: @escaping (Result<Block>) -> Void) {
		DispatchQueue.global(qos: .background).async {
		let result = instance.eth.getBlockByHash(blockHash)
			DispatchQueue.main.async {
				switch result {
				case .success(let block):
					completion(Result.success(block))
				case .failure(let error):
					completion(Result.failure(error))
				}
			}
		}
	}

	private static func add(timer: Timer) {
		shared.timers.append(timer)
	}

	private static func remove(timer: Timer) {
		shared.timers = shared.timers.filter { $0 != timer }
	}

}
