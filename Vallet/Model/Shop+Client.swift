//
//  Shop+Client.swift
//  Vallet
//
//  Created by Matija Kregar on 11/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

extension Shop {

	func delete() {
		managedObjectContext?.delete(self)
	}
	
}
