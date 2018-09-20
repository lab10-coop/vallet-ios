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
public class PriceList: NSManagedObject, Codable {

	convenience init?(in managedContext: NSManagedObjectContext, shop: Shop) {
		guard let entity = PriceList.entity(in: managedContext)
			else {
				return nil
		}
		self.init(entity: entity, insertInto: managedContext)
		self.shop = shop
		self.name = shop.name
	}

	// MARK: - Codable

	enum CodingKeys: String, CodingKey {
		case products
		case name = "token_name"
		case type = "token_type"
		case shopAddress = "token_contract_address"
		case secret
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(name ?? shop?.name, forKey: .name)
		try container.encode(0, forKey: .type)
		try container.encode(shop?.address, forKey: .shopAddress)
		try container.encode(products?.array as? [Product], forKey: .products)
	}

	public required convenience init(from decoder: Decoder) throws {
		guard let contextUserInfoKey = CodingUserInfoKey.context,
			let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
			let entity = PriceList.entity(in: managedObjectContext) else {
				fatalError("Failed to resolve the PriceList ")
		}
		self.init(entity: entity, insertInto: managedObjectContext)

		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try values.decode(String.self, forKey: .name)
		let shopAddress = try values.decode(String.self, forKey: .shopAddress)
		self.shop = findShop(in: managedObjectContext, with: shopAddress)
		let productsArray = try values.decode([Product]?.self, forKey: .products)
		if let productsArray = productsArray {
			self.products = NSOrderedSet(array: productsArray)
		}
		if let decodedSecret = try? values.decode(String.self, forKey: .secret) {
			self.secret = decodedSecret
		}
	}

	private func findShop(in managedContext: NSManagedObjectContext, with address: String) -> Shop? {
		// TODO: Implement this with a predicate instead of using filter
		let shops = (try? managedContext.fetch(Shop.fetchRequest())) as? [Shop]
		return shops?.filter({ $0.address == address }).first
	}

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
