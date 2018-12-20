//
//  UserDefaultsManager.swift
//  Vallet
//
//  Created by Matija Kregar on 19/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

class UserDefaultsManager {

	static var selectedShopAddress: String? {
		set {
			UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultsKey.selectedShopAddress)
			UserDefaults.standard.synchronize()
		}
		get {
			return UserDefaults.standard.value(forKey: Constants.UserDefaultsKey.selectedShopAddress) as? String
		}
	}

	static var userName: String? {
		set {
			UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultsKey.userName)
			UserDefaults.standard.synchronize()
		}
		get {
			return UserDefaults.standard.value(forKey: Constants.UserDefaultsKey.userName) as? String
		}
	}

}
