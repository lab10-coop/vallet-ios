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
public class PendingValueEvent: NSManagedObject {

	convenience init?(in managedContext: NSManagedObjectContext, shop: Shop, type: ValueEventType, value: Int64, productName: String? = nil,  clientAddress: String, date: Date) {
		guard let entity = PendingValueEvent.entity(in: managedContext)
			else {
				return nil
		}
		self.init(entity: entity, insertInto: managedContext)
		self.type = type.rawValue
		self.value = value
		self.clientAddress = clientAddress
		self.storedDate = date as NSDate
		self.productName = productName
		self.shop = shop
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
	@NSManaged public var type: String
	@NSManaged public var storedDate: NSDate
	@NSManaged public var productName: String?
	@NSManaged public var shop: Shop?

}

