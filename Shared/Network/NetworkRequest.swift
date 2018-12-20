//
//  NetworkRequest.swift
//  Vallet
//
//  Created by Matija Kregar on 20/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

public protocol URLRequestConvertible {

	func asURLRequest() -> URLRequest?

}

enum NetworkRequest: URLRequestConvertible {

	case getFunds(address: String)

	private var method: HTTPMethod {
		switch self {
		case .getFunds:
			return .get
		}
	}

	private var host: String {
		switch self {
		case .getFunds:
			return Constants.BlockChain.faucetServerAddress
		}
	}

	private var path: String {
		switch self {
		case .getFunds(let address):
			return "ats/\(address)"
		}
	}

	func asURLRequest() -> URLRequest? {
		guard let url = URL(string: host)
			else {
				return nil
		}
		var urlRequest = URLRequest(url: url.appendingPathComponent(path))
		urlRequest.httpMethod = method.rawValue

		urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
		urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

		switch self {
		case .getFunds:
			return urlRequest
		}
	}

}
