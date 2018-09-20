//
//  PriceList.swift
//  Vallet
//
//  Created by Matija Kregar on 20/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import CoreData

@objc(PriceList)
public class PriceList: NSManagedObject {

}


extension PriceList {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<PriceList> {
		return NSFetchRequest<PriceList>(entityName: "PriceList")
	}

	static func entity(in managedContext: NSManagedObjectContext) -> NSEntityDescription? {
		return NSEntityDescription.entity(forEntityName: "PriceList", in: managedContext)
	}

	@NSManaged public var name: String?
	@NSManaged public var secret: String?
	@NSManaged public var shop: Shop?
	@NSManaged public var products: NSOrderedSet?

}

// MARK: Generated accessors for products
extension PriceList {

	@objc(insertObject:inProductsAtIndex:)
	@NSManaged public func insertIntoProducts(_ value: Product, at idx: Int)

	@objc(removeObjectFromProductsAtIndex:)
	@NSManaged public func removeFromProducts(at idx: Int)

	@objc(insertProducts:atIndexes:)
	@NSManaged public func insertIntoProducts(_ values: [Product], at indexes: NSIndexSet)

	@objc(removeProductsAtIndexes:)
	@NSManaged public func removeFromProducts(at indexes: NSIndexSet)

	@objc(replaceObjectInProductsAtIndex:withObject:)
	@NSManaged public func replaceProducts(at idx: Int, with value: Product)

	@objc(replaceProductsAtIndexes:withProducts:)
	@NSManaged public func replaceProducts(at indexes: NSIndexSet, with values: [Product])

	@objc(addProductsObject:)
	@NSManaged public func addToProducts(_ value: Product)

	@objc(removeProductsObject:)
	@NSManaged public func removeFromProducts(_ value: Product)

	@objc(addProducts:)
	@NSManaged public func addToProducts(_ values: NSOrderedSet)

	@objc(removeProducts:)
	@NSManaged public func removeFromProducts(_ values: NSOrderedSet)

}
