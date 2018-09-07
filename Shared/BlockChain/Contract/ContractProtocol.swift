//
//  ContractProtocol.swift
//  Vallet
//
//  Created by Matija Kregar on 06/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import web3swift

protocol ContractProtocol {

	var jsonABI: String { get }
	var contract: web3.web3contract? { get }
	
}
