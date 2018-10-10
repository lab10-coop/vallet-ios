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

	var blockNumber: UInt64 {
		return UInt64(storedBlockNumber)
	}

	var type: ValueEventType? {
		return ValueEventType(rawValue: storedType)
	}

	convenience init?(in managedContext: NSManagedObjectContext, shop: Shop, intermediate: ValueEventIntermediate) {
		self.init(
			in: managedContext,
			shop: shop,
			value: intermediate.value,
			clientAddress: intermediate.clientAddress.address,
			type: intermediate.type,
			transactionHash: intermediate.transactionHash,
			blockHash: intermediate.blockHash,
			blockNumber: intermediate.blockNumber,
			status: intermediate.status,
			date: intermediate.date)
	}

	convenience init?(from pendingValueEvent: PendingValueEvent, blockHash: String, blockNumber: Int64, status: ValueEventStatus) {
		guard let managedObjectContext = pendingValueEvent.managedObjectContext,
			let shop = pendingValueEvent.shop,
			let type = pendingValueEvent.type
			else {
				return nil
		}
		self.init(in: managedObjectContext, shop: shop, value: pendingValueEvent.value, productName: pendingValueEvent.productName, clientAddress: pendingValueEvent.clientAddress, type: type, transactionHash: pendingValueEvent.transactionHash, blockHash: blockHash, blockNumber: blockNumber, status: status, date: pendingValueEvent.storedDate as Date)
	}

	convenience init?(in managedContext: NSManagedObjectContext, shop: Shop, value: Int64, productName: String? = nil, clientAddress: String, type: ValueEventType, transactionHash: String, blockHash: String, blockNumber: Int64, status: ValueEventStatus, date: Date? = nil) {
		guard let entity = ValueEvent.entity(in: managedContext)
			else {
				return nil
		}
		self.init(entity: entity, insertInto: managedContext)
		self.value = value
		self.clientAddress = clientAddress
		self.storedType = type.rawValue
		self.status = status.rawValue
		self.blockHash = blockHash
		self.storedBlockNumber = blockNumber
		self.storedDate = date as NSDate?
		self.transactionHash = transactionHash
		self.productName = productName
		self.shop = shop
	}

}

extension ValueEvent {

	var uniqueHash: Int {
		return self.clientAddress.hashValue ^ self.value.hashValue ^ self.blockHash.hashValue ^ self.storedType.hashValue
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

	@NSManaged public var transactionHash: String
	@NSManaged public var value: Int64
	@NSManaged public var clientAddress: String
	@NSManaged public var storedType: String
	@NSManaged public var status: String
	@NSManaged public var blockHash: String
	@NSManaged public var storedBlockNumber: Int64
	@NSManaged public var storedDate: NSDate?
	@NSManaged public var productName: String?
	@NSManaged public var shop: Shop?
	@NSManaged public var client: User?

}

