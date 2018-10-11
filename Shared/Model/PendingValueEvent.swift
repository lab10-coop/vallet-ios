//
//  PendingValueEvent.swift
//  Vallet
//
//  Created by Matija Kregar on 19/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import CoreData

@objc(PendingValueEvent)
public class PendingValueEvent: NSManagedObject, EventValuable {

	var type: ValueEventType? {
		return ValueEventType(rawValue: storedType)
	}

	var client: User? {
		guard let managedObjectContext = managedObjectContext
			else {
				return nil
		}
		return User.user(in: managedObjectContext, with: clientAddress)
	}

	convenience init?(in managedContext: NSManagedObjectContext, shop: Shop, type: ValueEventType, value: Int64, productName: String? = nil, clientAddress: String, date: Date, transactionHash: String) {
		guard let entity = PendingValueEvent.entity(in: managedContext)
			else {
				return nil
		}
		self.init(entity: entity, insertInto: managedContext)
		self.storedType = type.rawValue
		self.value = value
		self.clientAddress = clientAddress
		self.storedDate = date as NSDate
		self.productName = productName
		self.shop = shop
		self.transactionHash = transactionHash
		self.needsRetry = false
	}

	func delete() {
		managedObjectContext?.delete(self)
	}

}


extension PendingValueEvent {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<PendingValueEvent> {
		return NSFetchRequest<PendingValueEvent>(entityName: "PendingValueEvent")
	}

	static func entity(in managedContext: NSManagedObjectContext) -> NSEntityDescription? {
		return NSEntityDescription.entity(forEntityName: "PendingValueEvent", in: managedContext)
	}

	@NSManaged public var value: Int64
	@NSManaged public var clientAddress: String
	@NSManaged public var storedType: String
	@NSManaged public var storedDate: NSDate
	@NSManaged public var productName: String?
	@NSManaged public var transactionHash: String
	@NSManaged public var shop: Shop?
	@NSManaged public var needsRetry: Bool

}

extension PendingValueEvent {

	static func events(in managedObjectContext: NSManagedObjectContext, shop: Shop) -> [PendingValueEvent]? {
		guard var pendingEvents = (try? managedObjectContext.fetch(PendingValueEvent.fetchRequest())) as? [PendingValueEvent]
			else {
				return nil
		}
		pendingEvents = pendingEvents.filter { $0.shop == shop }
		return pendingEvents.count > 0 ? pendingEvents : nil
	}
	
}

