//
//  QRCodeManager.swift
//  Vallet
//
//  Created by Matija Kregar on 28/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

class QRCodeManager {

	static func shopAddressCode(for address: String) -> String {
		let string = "\(Constants.Deeplink.clientScheme)\(Constants.Deeplink.shop)/\(address)"
		return string
	}

	static func userAddressCode(for address: String, userName: String?) -> String? {
		let string = "\(Constants.Deeplink.adminScheme)\(Constants.Deeplink.user)/\(address)"
		var urlComponents = URLComponents(string: string)
		var queryItems = [URLQueryItem]()
		
		if let userName = userName,
			!userName.isEmpty {
			let usernameItem = URLQueryItem(name: Constants.Deeplink.QueryKey.userName, value: userName)
			queryItems.append(usernameItem)
		}

		if queryItems.count > 0 {
			urlComponents?.queryItems = queryItems
		}

		return urlComponents?.url?.absoluteString
	}

	static func shopAddress(from code: String) -> String? {
		guard let urlComponents = URLComponents(string: code),
			urlComponents.host == Constants.Deeplink.shop
			else {
				return nil
		}
		var address = urlComponents.path
		address.removeFirst()
		return address
	}

	static func userAddress(from code: String) -> String? {
		guard let urlComponents = URLComponents(string: code),
			urlComponents.host == Constants.Deeplink.user
			else {
				return nil
		}
		var address = urlComponents.path
		address.removeFirst()
		return address
	}

	static func userName(from code: String) -> String? {
		guard let urlComponents = URLComponents(string: code),
			urlComponents.host == Constants.Deeplink.user,
			let queryItems = urlComponents.queryItems,
			let userItem = queryItems.filter({ $0.name == Constants.Deeplink.QueryKey.userName }).first
			else {
				return nil
		}
		return userItem.value
	}

}
