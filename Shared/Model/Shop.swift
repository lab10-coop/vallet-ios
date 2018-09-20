//
//  Shop+CoreDataClass.swift
//  
//
//  Created by Matija Kregar on 12/09/2018.
//
//

import Foundation
import CoreData
import web3swift

@objc(Shop)
public class Shop: NSManagedObject {

	convenience init?(in managedContext: NSManagedObjectContext, intermediate: ShopIntermediate) {
		self.init(in: managedContext,
							name: intermediate.name,
							address: intermediate.address.address,
							decimals: Int16(intermediate.decimals),
							symbol: intermediate.symbol,
							creatorAddress: intermediate.creatorAddress.address)
	}

	convenience init?(in managedContext: NSManagedObjectContext, name: String, address: String? = nil, decimals: Int16 = 12, symbol: TokenType, creatorAddress: String) {
		guard let entity = Shop.entity(in: managedContext)
			else {
				return nil
		}
		self.init(entity: entity, insertInto: managedContext)
		self.name = name
		self.address = address
		self.decimals = decimals
		self.symbol = symbol.rawValue
		self.creatorAddress = creatorAddress
	}

}

extension Shop {

	override public var description: String {
		return "Shop name: \(name), address: \(address ?? "")"
	}

}

// MARK: - NSManaged properties extension

extension Shop {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<Shop> {
		return NSFetchRequest<Shop>(entityName: "Shop")
	}

	static func entity(in managedContext: NSManagedObjectContext) -> NSEntityDescription? {
		return NSEntityDescription.entity(forEntityName: "Shop", in: managedContext)
	}

	@NSManaged public var name: String
	@NSManaged public var address: String?
	@NSManaged public var decimals: Int16
	@NSManaged public var symbol: String
	@NSManaged public var creatorAddress: String
	@NSManaged public var priceList: PriceList?
	@NSManaged public var events: NSSet?
	@NSManaged public var pendingEvents: NSSet?

}

// MARK: Generated accessors for events
extension Shop {

	@objc(addEventsObject:)
	@NSManaged public func addToEvents(_ value: ValueEvent)

	@objc(removeEventsObject:)
	@NSManaged public func removeFromEvents(_ value: ValueEvent)

	@objc(addEvents:)
	@NSManaged public func addToEvents(_ values: NSSet)

	@objc(removeEvents:)
	@NSManaged public func removeFromEvents(_ values: NSSet)

}

// MARK: Generated accessors for pendingEvents
extension Shop {

	@objc(addPendingEventsObject:)
	@NSManaged public func addToPendingEvents(_ value: PendingValueEvent)

	@objc(removePendingEventsObject:)
	@NSManaged public func removeFromPendingEvents(_ value: PendingValueEvent)

	@objc(addPendingEvents:)
	@NSManaged public func addToPendingEvents(_ values: NSSet)

	@objc(removePendingEvents:)
	@NSManaged public func removeFromPendingEvents(_ values: NSSet)

}
