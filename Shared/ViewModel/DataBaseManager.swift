//
//  DataBaseManager.swift
//  Vallet
//
//  Created by Matija Kregar on 12/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import CoreData

class DataBaseManager {

	private static var shared = DataBaseManager()

	lazy private var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Model")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			// TODO: Replace this implementation with code to handle the error appropriately.
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

	static var managedContext: NSManagedObjectContext {
		return shared.persistentContainer.viewContext
	}

	static func save(managedContext: NSManagedObjectContext? = nil) {
		let managedContext = managedContext ?? self.managedContext
		managedContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
		if managedContext.hasChanges {
			try? managedContext.save()
		}
	}

}
