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
		guard let faucetURL = URL(string: "\(Constants.BlockChain.faucetServerAddress)addr/\(address.address)")
			else {
				return
		}
		var request = URLRequest(url: faucetURL)
		request.httpMethod = "GET"

		let session = URLSession(configuration: .default)
		let task = session.dataTask(with: request) { (data, response, error) in
			if let error = error {
					completion(Result.failure(error))
					return
			}
			completion(Result.success(true))
		}

		task.resume()
	}

}
