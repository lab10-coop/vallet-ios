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
public class Product: NSManagedObject {

}


extension Product {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
		return NSFetchRequest<Product>(entityName: "Product")
	}

	static func entity(in managedContext: NSManagedObjectContext) -> NSEntityDescription? {
		return NSEntityDescription.entity(forEntityName: "Product", in: managedContext)
	}

	@NSManaged public var name: String?
	@NSManaged public var price: Int64
	@NSManaged public var imagePath: String?
	@NSManaged public var nfcTagId: String?
	@NSManaged public var priceList: PriceList?

}


