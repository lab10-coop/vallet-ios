//
//  EventValuable.swift
//  Vallet
//
//  Created by Matija Kregar on 10/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

protocol EventValuable {

	var value: Int64 {get set}
	var productName: String? {get set}
	var clientAddress: String {get set}
	var client: User? {get}
	var type: ValueEventType? {get}

}
