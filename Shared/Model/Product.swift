//
//  Product.swift
//  Vallet
//
//  Created by Matija Kregar on 20/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import web3swift

@objc(Product)
public class Product: NSManagedObject, Codable {

	convenience init?(in managedContext: NSManagedObjectContext, data: ProductData) {
		self.init(in: managedContext, name: data.name, price: data.price, imagePath: data.imagePath, nfcTagId: data.nfcTagId)
	}

	convenience init?(in managedContext: NSManagedObjectContext, name: String, price: Int64, imagePath: String?, nfcTagId: String?, image: UIImage? = nil) {
		guard let entity = Product.entity(in: managedContext)
			else {
				return nil
		}
		self.init(entity: entity, insertInto: managedContext)
		self.name = name
		self.price = price
		self.imagePath = imagePath
		self.nfcTagId = nfcTagId

		if let image = image {
			self.externalImage = ExternalImage(in: managedContext, image: image, path: imagePath)
		}
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
	@NSManaged public var externalImage: ExternalImage?

}

// MARK: - Image loading

extension Product {

	// Only return image if it is saved and up to date.
	var image: UIImage? {
		if let externalImage = externalImage,
			let savedImagePath = externalImage.imagePath,
			savedImagePath == imagePath {
			return externalImage.image
		}
		return nil
	}

	func updateImage(completion: @escaping (Result<UIImage>) -> Void) {
		// Image is saved and up to date.
		if let image = image {
			completion(Result.success(image))
		}
		// Image has to be loaded.
		else if let imagePath = imagePath {
			IPFSManager.loadImage(hash: imagePath) { [weak self] (imageResult) in
				switch imageResult {
				case .success(let loadedImage):
					completion(Result.success(loadedImage))
					if let managedContext = self?.managedObjectContext {
						let newImage = ExternalImage(in: managedContext, image: loadedImage, path: imagePath)
						self?.externalImage = newImage
						DataBaseManager.save(managedContext: managedContext)
					}
				case .failure(let error):
					completion(Result.failure(error))
				}
			}
		}
		// There is no image
		else {
			completion(Result.failure(Web3Error.dataError))
		}
	}

}

// MARK: - ProductData struct

// used for decoding and updating
struct ProductData: Decodable {

	var name: String
	var price: Int64
	var imagePath: String?
	var nfcTagId: String?

}


