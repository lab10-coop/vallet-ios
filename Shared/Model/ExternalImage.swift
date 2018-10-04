//
//  ExternalImage.swift
//  Vallet
//
//  Created by Matija Kregar on 03/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(ExternalImage)
public class ExternalImage: NSManagedObject {

	var image: UIImage? {
		return storedImage.image
	}

	convenience init?(in managedContext: NSManagedObjectContext, image: UIImage, path: String? = nil) {
		guard let data = image.jpegData(compressionQuality: Constants.Image.jpegCompression)
			else {
				return nil
		}
		self.init(in: managedContext, data: data, path: path)
	}

	convenience init?(in managedContext: NSManagedObjectContext, data: Data, path: String? = nil) {
		guard let entity = ExternalImage.entity(in: managedContext),
			let storedImage = StoredImage(in: managedContext, data: data)
			else {
				return nil
		}
		self.init(entity: entity, insertInto: managedContext)
		self.storedImage = storedImage
		self.imagePath = path
	}

}

extension ExternalImage {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<ExternalImage> {
		return NSFetchRequest<ExternalImage>(entityName: "ExternalImage")
	}

	static func entity(in managedContext: NSManagedObjectContext) -> NSEntityDescription? {
		return NSEntityDescription.entity(forEntityName: "ExternalImage", in: managedContext)
	}

	@NSManaged public var imagePath: String?
	@NSManaged public var storedImage: StoredImage
	@NSManaged public var product: Product?

}

// MARK: - Query

extension ExternalImage {

	static func image(in managedContext: NSManagedObjectContext, with imagePath: String) -> ExternalImage? {
		let fetchRequest: NSFetchRequest<ExternalImage> = ExternalImage.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "imagePath == %@", imagePath)
		let images = try? managedContext.fetch(fetchRequest)
		return images?.first
	}

}

