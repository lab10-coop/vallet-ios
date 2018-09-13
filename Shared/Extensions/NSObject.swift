//
//  NSObject.swift
//  Vallet
//
//  Created by Matija Kregar on 13/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

extension NSObject {

	// TODO: Check if this can be done wihtout force unwrapping.
	public static var className: String {
		return NSStringFromClass(self).components(separatedBy: ".").last!
	}

	public var className: String {
		return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
	}

}
