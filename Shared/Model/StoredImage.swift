//
//  StoredImage.swift
//  Vallet
//
//  Created by Matija Kregar on 03/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(StoredImage)
public class StoredImage: NSManagedObject {

	var image: UIImage? {
		return UIImage(data: imageData as Data)
	}

	convenience init?(in managedContext: NSManagedObjectContext, data: Data) {
		guard let entity = StoredImage.entity(in: managedContext)
			else {
				return nil
		}
		self.init(entity: entity, insertInto: managedContext)
		self.imageData = data as NSData
	}

}

extension StoredImage {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<StoredImage> {
		return NSFetchRequest<StoredImage>(entityName: "StoredImage")
	}

	static func entity(in managedContext: NSManagedObjectContext) -> NSEntityDescription? {
		return NSEntityDescription.entity(forEntityName: "StoredImage", in: managedContext)
	}

	@NSManaged public var imageData: NSData
	@NSManaged public var externalImage: ExternalImage?

}
