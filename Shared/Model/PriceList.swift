//
//  PriceList.swift
//  Vallet
//
//  Created by Matija Kregar on 20/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import CoreData

extension Encodable {
	func toJSONData() throws -> Data {
		return try JSONEncoder().encode(self)
	}
}

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

	static func create(in managedContext: NSManagedObjectContext, jsonData: Data) throws -> PriceList {
		guard let jsonDecoder = JSONDecoder(with: managedContext)
			else {
				throw ValletError.unwrapping(property: "jsonDecoder", object: "PriceList", function: #function)
		}
		do {
			let priceList = try jsonDecoder.decode(PriceList.self, from: jsonData)
			return priceList
		}
		catch {
			throw error
		}
	}

	// MARK: - Codable

	var jsonData: Data? {
		let jsonData = try? self.toJSONData()
		return jsonData
	}

	enum CodingKeys: String, CodingKey {
		case products
		case name = "tokenName"
		case type = "tokenType"
		case shopAddress = "tokenContractAddress"
		case version = "version"
	}

	public func encode(to encoder: Encoder) throws {
		guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
			else {
				throw ValletError.unwrapping(property: "Version", object: "Info.plist", function: #function)
		}
		guard let shop = shop
			else {
				throw ValletError.unwrapping(property: "Shop", object: "PriceList", function: #function)
		}
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(name ?? shop.name, forKey: .name)
		try container.encode(shop.tokenType?.rawValue, forKey: .type)
		try container.encode(appVersion, forKey: .version)
		try container.encode(shop.address, forKey: .shopAddress)
		let productsArray = products?.array as? [Product] ?? [Product]()
		try container.encode(productsArray, forKey: .products)
	}

	public required convenience init(from decoder: Decoder) throws {
		guard let contextUserInfoKey = CodingUserInfoKey.context,
			let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
			let entity = PriceList.entity(in: managedObjectContext) else {
				throw ValletError.dataDecoding(object: "Product", function: #function)
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
		updateProducts(with: priceListData.products)

		DataBaseManager.save(managedContext: managedObjectContext)
		return true
	}

	private func updateProducts(with newProductsData: [ProductData]) {
		// Only transfer images from the existing products
		guard let managedObjectContext = self.managedObjectContext,
			let existingProducts = self.products?.copy() as? NSOrderedSet?
			else{
				return
		}

		for productData in newProductsData {
			if let product = Product(in: managedObjectContext, data: productData) {
				if let imagePath = product.imagePath,
					let image = ExternalImage.image(in: managedObjectContext, with: imagePath) {
					product.externalImage = image
				}
				self.addToProducts(product)
			}
		}
		delete(products: existingProducts)
	}

	func delete(products set: NSOrderedSet?) {
		guard let managedObjectContext = self.managedObjectContext,
			let set = set
			else {
				return
		}
		for case let product as NSManagedObject in set {
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
