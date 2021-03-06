//
//  NetworkManager.swift
//  Vallet
//
//  Created by Matija Kregar on 20/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

class NetworkManager {

	static func performDataRequest(request: URLRequestConvertible, completion: @escaping (Result<Data?>) -> Void) {
		guard let urlRequest = request.asURLRequest()
			else {
				completion(Result.failure(ValletError.unwrapping(property: "urlRequest", object: "NetworkManager", function: #function)))
				return
		}

		let session = URLSession(configuration: .default)
		let task = session.dataTask(with: urlRequest) { (data, response, error) in
			DispatchQueue.main.async {
				if let error = error {
					completion(Result.failure(error))
					return
				}
				completion(Result.success(data))
			}
		}

		task.resume()
	}

}
