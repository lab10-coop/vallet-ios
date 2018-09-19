//
//  ValueEvent.swift
//  Vallet
//
//  Created by Matija Kregar on 18/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import CoreData
import web3swift

public enum ValueEventType: String {
	case redeem
	case issue
}

public enum ValueEventStatus: String {
	case ok
	case failed
	case unknown

	init(from status: TransactionReceipt.TXStatus) {
		switch status {
		case .ok:
			self = .ok
		case .failed:
			self = .failed
		case .notYetProcessed:
			self = .unknown
		}
	}
}

@objc(ValueEvent)
public class ValueEvent: NSManagedObject {

	var date: Date? {
		get {
			return storedDate as Date?
		}
		set {
			storedDate = newValue as NSDate?
		}
	}

	var blockHash: Data {
		return storedBlockHash as Data
	}

	var transactionHash: Data {
		return storedTransactionHash as Data
	}

	convenience init?(in managedContext: NSManagedObjectContext, shop: Shop, intermediate: ValueEventIntermediate) {
		self.init(
			in: managedContext,
			shop: shop,
			value: intermediate.value,
			clientAddress: intermediate.clientAddress.address,
			type: intermediate.type,
			transactionHash:intermediate.transactionHash,
			blockHash: intermediate.blockHash,
			status: intermediate.status,
			date: intermediate.date)
	}

	convenience init?(from pendingValueEvent: PendingValueEvent, transactionHash: Data, blockHash: Data, status: ValueEventStatus) {
		guard let managedObjectContext = pendingValueEvent.managedObjectContext,
			let shop = pendingValueEvent.shop,
			let type = ValueEventType(rawValue: pendingValueEvent.type)
			else {
				return nil
		}
		self.init(in: managedObjectContext, shop: shop, value: pendingValueEvent.value, clientAddress: pendingValueEvent.clientAddress, type: type, transactionHash: transactionHash, blockHash: blockHash, status: status, date: pendingValueEvent.storedDate as Date)
		pendingValueEvent.delete()
	}

	convenience init?(in managedContext: NSManagedObjectContext, shop: Shop, value: Int64, clientAddress: String, type: ValueEventType, transactionHash: Data, blockHash: Data, status: ValueEventStatus, date: Date? = nil) {
		guard let entity = ValueEvent.entity(in: managedContext)
			else {
				return nil
		}
		self.init(entity: entity, insertInto: managedContext)
		self.value = value
		self.clientAddress = clientAddress
		self.type = type.rawValue
		self.status = status.rawValue
		self.storedBlockHash = blockHash as NSData
		self.storedDate = date as NSDate?
		self.storedTransactionHash = transactionHash as NSData
		self.shop = shop
	}

}

extension ValueEvent {

	var uniqueHash: Int {
		return self.clientAddress.hashValue ^ self.value.hashValue ^ self.storedBlockHash.hashValue ^ self.type.hashValue
	}

}

// MARK: - NSManaged properties extension

extension ValueEvent {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<ValueEvent> {
		return NSFetchRequest<ValueEvent>(entityName: "ValueEvent")
	}

	static func entity(in managedContext: NSManagedObjectContext) -> NSEntityDescription? {
		return NSEntityDescription.entity(forEntityName: "ValueEvent", in: managedContext)
	}

	@NSManaged public var storedTransactionHash: NSData
	@NSManaged public var value: Int64
	@NSManaged public var clientAddress: String
	@NSManaged public var type: String
	@NSManaged public var status: String
	@NSManaged public var storedBlockHash: NSData
	@NSManaged public var storedDate: NSDate?
	@NSManaged public var shop: Shop?

}

