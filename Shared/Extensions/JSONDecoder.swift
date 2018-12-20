//
//  JSONDecoder.swift
//  Vallet
//
//  Created by Matija Kregar on 20/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import CoreData

extension JSONDecoder {

	convenience init?(with managedObjcectContext: NSManagedObjectContext) {
		guard let contextInfoKey = CodingUserInfoKey.context
			else {
				return nil
		}
		self.init()
		self.userInfo[contextInfoKey] = managedObjcectContext
	}

}
