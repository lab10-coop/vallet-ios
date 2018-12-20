//
//  PendingEventManager.swift
//  Vallet
//
//  Created by Matija Kregar on 10/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

class PendingEventManager {

	static func makeValueEvent(from pendingValueEvent: PendingValueEvent, completion: @escaping (Result<Bool>) -> Void) {
		Web3Manager.getTransactionReceipt(for: pendingValueEvent.transactionHash) { (receiptResult) in
			switch receiptResult {
			case .success(let receipt):
				let success = receipt.status == .ok
				guard let _ = ValueEvent(from: pendingValueEvent, blockHash: receipt.blockHash.hashString, blockNumber: Int64(receipt.blockNumber), status: ValueEventStatus(from: receipt.status))
					else {
						completion(Result.failure(ValletError.storeInsertion(object: "ValueEvent", function: #function)))
						return
				}
				print("got receipt")
				pendingValueEvent.delete()
				DataBaseManager.save(managedContext: pendingValueEvent.managedObjectContext)
				NotificationCenter.default.post(name: Constants.Notification.newValueEvent, object: nil)
				completion(Result.success(success))
			case .failure(let error):
				pendingValueEvent.needsRetry = true
				DataBaseManager.save(managedContext: pendingValueEvent.managedObjectContext)
				completion(Result.failure(error))
			}
		}
	}

}
