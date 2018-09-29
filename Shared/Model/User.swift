//
//  User.swift
//  Vallet
//
//  Created by Matija Kregar on 28/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {

	convenience init?(in managedContext: NSManagedObjectContext, address: String, name: String? = nil) {
		guard let entity = User.entity(in: managedContext)
			else {
				return nil
		}
		self.init(entity: entity, insertInto: managedContext)
		self.name = name
		self.address = address
	}

	static func user(in managedContext: NSManagedObjectContext, with address: String) -> User? {
		// TODO: Implement this with a predicate instead of using filter
		let users = (try? managedContext.fetch(User.fetchRequest())) as? [User]
		return users?.filter({ $0.address == address }).first
	}

}

extension User {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
		return NSFetchRequest<User>(entityName: "User")
	}

	static func entity(in managedContext: NSManagedObjectContext) -> NSEntityDescription? {
		return NSEntityDescription.entity(forEntityName: "User", in: managedContext)
	}

	@NSManaged public var name: String?
	@NSManaged public var address: String?
	@NSManaged public var events: NSSet?

}

// MARK: Generated accessors for events
extension User {

	@objc(addEventsObject:)
	@NSManaged public func addToEvents(_ value: ValueEvent)

	@objc(removeEventsObject:)
	@NSManaged public func removeFromEvents(_ value: ValueEvent)

	@objc(addEvents:)
	@NSManaged public func addToEvents(_ values: NSSet)

	@objc(removeEvents:)
	@NSManaged public func removeFromEvents(_ values: NSSet)

}

