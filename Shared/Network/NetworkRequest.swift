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
	case getPriceList(address: String)
	case update(priceList: Data)
	case createNew(priceList: Data)

	private var method: HTTPMethod {
		switch self {
		case .getFunds,
				 .getPriceList:
			return .get

		case .update:
			return .put

		case .createNew:
			return .post
		}
	}

	private var host: String {
		return Constants.Network.apiHost
	}

	private var path: String {
		switch self {
		case .getFunds(let address):
			return "\(Constants.BlockChain.faucetServerAddress)addr/\(address)"

		case .getPriceList(let address):
			return "/price_lists/\(address)"

		case .update,
			.createNew:
			return "/price_lists"
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
		case .createNew(let data),
				 .update(let data):
			urlRequest.httpBody = data
			return urlRequest
			
		default:
			return urlRequest
		}
	}

}
