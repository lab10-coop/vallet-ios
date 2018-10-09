//
//  ErrorContaining.swift
//  Vallet
//
//  Created by Matija Kregar on 09/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

protocol ErrorContaining {
	var error: Error? {get set}
}
