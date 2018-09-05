//
//  Result.swift
//  Vallet
//
//  Created by Matija Kregar on 05/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

public enum Result<T> {

	case success(T)
	case failure(Error)
	
}
