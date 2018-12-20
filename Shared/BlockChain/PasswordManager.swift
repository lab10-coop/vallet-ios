//
//  PasswordManager.swift
//  Vallet
//
//  Created by Matija Kregar on 03/12/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import KeychainAccess

struct PasswordManager {
	
	private static let passwordLength = 32
	private static let keychainService = "ValletPassStore"
	private static let walletKeystorePasswordKey = "WalletKeystorePasswordKey"
	
	static private var newPassword: String {
		let length = passwordLength
		let passwordChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!#$%&()=?*_:;><⁄@‹›€"
		let password = String((0..<length).compactMap{ _ in passwordChars.randomElement() })
		return password
	}
	
	static var storedPassword: String? {
		let keychain = Keychain(service: keychainService)
		guard let password = keychain[walletKeystorePasswordKey]
			else {
				return nil
		}
		return password
	}
	
	static func createAndStorePassword() -> String {
		if let storedPassword = storedPassword {
			return storedPassword
		}
		
		let keychain = Keychain(service: keychainService)
		let password = newPassword
		keychain[walletKeystorePasswordKey] = password
		
		return password
	}
	
}
