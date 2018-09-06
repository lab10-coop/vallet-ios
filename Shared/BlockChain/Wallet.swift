//
//  Wallet.swift
//  Vallet
//
//  Created by Matija Kregar on 05/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import web3swift

class Wallet {

	static let shared = Wallet()

	private var _keystoreManager: KeystoreManager?
	private var _keystore: EthereumKeystoreV3?

	static var address: EthereumAddress {
		guard let address = keystore.addresses?.first
			else {
				fatalError("no address found")
		}
		return address
	}

	static var keystore: EthereumKeystoreV3 {
		// return keystore from memory
		if let keystore = shared._keystore {
			return keystore
		}

		// return keystore from file
		if let address = keystoreManager.addresses?.first,
			let retrievedKeystore = keystoreManager.walletForAddress(address) as? EthereumKeystoreV3 {
			shared._keystore = retrievedKeystore
			return retrievedKeystore
		}

		// create new keystore
		let newKeystore = createNewKeystore()
		shared._keystore = newKeystore
		return newKeystore
	}

	static var keystoreManager: KeystoreManager {
		// return keystore from memory
		if let keystoreManager = shared._keystoreManager {
			return keystoreManager
		}

		guard let userDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
			let newKeystoreManager = KeystoreManager.managerForPath(userDirectory + "/keystore")
			else {
				fatalError("Couldn't create a KeystoreManager.")
		}
		shared._keystoreManager = newKeystoreManager
		return newKeystoreManager
	}

	static private func createNewKeystore() -> EthereumKeystoreV3 {
		do {
			guard let newKeystore = try EthereumKeystoreV3(password: Constants.Temp.keystorePassword)
				else {
					fatalError("Couldn't create a new Keystore..")
			}
			shared._keystore = newKeystore
			
			let newKeystoreJSON = try JSONEncoder().encode(newKeystore.keystoreParams)
			FileManager.default.createFile(atPath: "\(keystoreManager.path)/keystore.json", contents: newKeystoreJSON, attributes: nil)

			return newKeystore
		} catch {
			fatalError("Couldn't create and save a new Keystore. Error: \(error)")
		}
	}

}
