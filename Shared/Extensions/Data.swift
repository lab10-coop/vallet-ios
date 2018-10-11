//
//  Data.swift
//  Vallet
//
//  Created by Matija Kregar on 10/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

extension Data {

	var hashString: String {
		var hash = self.toHexString()
		if !hash.hasPrefix("0x") {
			hash = "0x" + hash
		}
		return hash
	}

}
