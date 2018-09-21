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

	static func create(in managedContext: NSManagedObjectContext, jsonData: Data) -> PriceList? {
		guard let jsonDecoder = JSONDecoder(with: managedContext)
			else {
				return nil
		}
		let priceList = try? jsonDecoder.decode(PriceList.self, from: jsonData)
		return priceList
	}

	// MARK: - Codable

	var jsonData: Data? {
		let jsonEncoder = JSONEncoder()
		let jsonData = try? jsonEncoder.encode(self)
		return jsonData
	}

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
		let productsArray = products?.array as? [Product] ?? [Product]()
		try container.encode(productsArray, forKey: .products)
		if let secret = secret {
			try container.encode(secret, forKey: .secret)
		}
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
		self.shop = Shop.shop(in: managedObjectContext, with: shopAddress)
		let productsArray = try values.decode([Product]?.self, forKey: .products)
		if let productsArray = productsArray {
			self.products = NSOrderedSet(array: productsArray)
		}
		if let decodedSecret = try? values.decode(String.self, forKey: .secret) {
			self.secret = decodedSecret
		}
	}

}

// MARK: - Core Data

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

// MARK: - Update helpers

extension PriceList {

	func update(with data: Data) -> Bool {
		guard let priceListData = PriceListData.decode(from: data),
			let managedObjectContext = self.managedObjectContext,
			self.shop?.address == priceListData.shopAddress
			else {
				return false
		}
		self.name = priceListData.name
		deletaAllProducts()
		for productData in priceListData.products {
			if let product = Product(in: managedObjectContext, data: productData) {
				self.addToProducts(product)
			}
		}
		DataBaseManager.save(managedContext: managedObjectContext)
		return true
	}

	func deletaAllProducts() {
		guard let managedObjectContext = self.managedObjectContext,
			let products = products
			else {
				return
		}
		for case let product as NSManagedObject in products {
			managedObjectContext.delete(product)
		}
		DataBaseManager.save(managedContext: managedObjectContext)
	}

}

// MARK: - PriceListData struct

// Used for parsing and updating
struct PriceListData: Decodable {

	var shopAddress: String
	var name: String
	var products = [ProductData]()

	enum CodingKeys: String, CodingKey {
		case products
		case name = "token_name"
		case shopAddress = "token_contract_address"
	}

	static func decode(from jsonData: Data) -> PriceListData? {
		let jsonDecoder = JSONDecoder()
		let priceListData = try? jsonDecoder.decode(PriceListData.self, from: jsonData)
		return priceListData
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try values.decode(String.self, forKey: .name)
		self.shopAddress = try values.decode(String.self, forKey: .shopAddress)

		if let products = try values.decode([ProductData]?.self, forKey: .products) {
			self.products = products
		}
	}

}
