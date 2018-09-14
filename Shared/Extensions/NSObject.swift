//
//  NSObject.swift
//  Vallet
//
//  Created by Matija Kregar on 13/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

extension NSObject {

	public static var className: String {
		return String(describing: self)
	}

	public var className: String {
		return String(describing: type(of: self))
	}

}
