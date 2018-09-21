//
//  Product.swift
//  Vallet
//
//  Created by Matija Kregar on 20/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import CoreData

@objc(Product)
public class Product: NSManagedObject, Codable {

	convenience init?(in managedContext: NSManagedObjectContext, data: ProductData) {
		self.init(in: managedContext, name: data.name, price: data.price, imagePath: data.imagePath, nfcTagId: data.nfcTagId)
	}

	convenience init?(in managedContext: NSManagedObjectContext, name: String, price: Int64, imagePath: String?, nfcTagId: String?) {
		guard let entity = Product.entity(in: managedContext)
			else {
				return nil
		}
		self.init(entity: entity, insertInto: managedContext)
		self.name = name
		self.price = price
		self.imagePath = imagePath
		self.nfcTagId = nfcTagId
	}

	// MARK: - Codable

	enum CodingKeys: String, CodingKey {
		case name
		case price
		case imagePath
		case nfcTagId
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(name, forKey: .name)
		try container.encode(price, forKey: .price)
		try container.encode(imagePath, forKey: .imagePath)
		try container.encode(nfcTagId, forKey: .nfcTagId)
	}

	public required convenience init(from decoder: Decoder) throws {
		guard let contextUserInfoKey = CodingUserInfoKey.context,
			let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
			let entity = Product.entity(in: managedObjectContext) else {
				// TODO: Implement proper error handling
				fatalError("Failed to resolve the Product ")
		}
		self.init(entity: entity, insertInto: managedObjectContext)

		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try values.decode(String.self, forKey: .name)
		self.price = try values.decode(Int64.self, forKey: .price)
		self.imagePath = try values.decode(String?.self, forKey: .imagePath)
		self.nfcTagId = try values.decode(String?.self, forKey: .nfcTagId)
	}

}

// MARK: - Core Data

extension Product {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
		return NSFetchRequest<Product>(entityName: "Product")
	}

	static func entity(in managedContext: NSManagedObjectContext) -> NSEntityDescription? {
		return NSEntityDescription.entity(forEntityName: "Product", in: managedContext)
	}

	@NSManaged public var name: String
	@NSManaged public var price: Int64
	@NSManaged public var imagePath: String?
	@NSManaged public var nfcTagId: String?
	@NSManaged public var priceList: PriceList?

}

// MARK: - ProductData struct

// used for decoding and updating
struct ProductData: Decodable {

	var name: String
	var price: Int64
	var imagePath: String?
	var nfcTagId: String?

}


