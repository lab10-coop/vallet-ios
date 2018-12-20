//
//  FaucetManager.swift
//  Vallet
//
//  Created by Matija Kregar on 05/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import web3swift

class FaucetManager {

	static func getFunds(for address: EthereumAddress, completion: @escaping (Result<Bool>) -> Void ) {
		NetworkManager.performDataRequest(request: NetworkRequest.getFunds(address: address.address)) { (result) in
			switch result {
			case .success:
				completion(Result.success(true))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

}
