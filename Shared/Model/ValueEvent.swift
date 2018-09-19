//
//  ValueEvent.swift
//  Vallet
//
//  Created by Matija Kregar on 18/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import CoreData

public enum ValueEventType: String {
	case redeem
	case issue
}

public enum ValueEventStatus: String {
	case ok
	case failed
	case unknown
}

@objc(ValueEvent)
public class ValueEvent: NSManagedObject {

	convenience init?(in managedContext: NSManagedObjectContext, shop: Shop?, intermediate: ValueEventIntermediate) {
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

	convenience init?(in managedContext: NSManagedObjectContext, shop: Shop? = nil, value: Int64, clientAddress: String, type: ValueEventType, transactionHash: Data, blockHash: Data, status: ValueEventStatus, date: Date? = nil) {
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

