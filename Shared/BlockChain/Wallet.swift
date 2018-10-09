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
	private var _address: EthereumAddress?

	static var address: EthereumAddress {
		guard let address = shared._address
			else {
				fatalError("no address found")
		}
		return address
	}

	private static func getAddress() throws -> EthereumAddress {
		do {
			let keystore = try getKeystore()
			guard let address = keystore.addresses?.first
				else {
					throw ValletError.wallet(object: "address", function: #function)
			}
			return address
		}
		catch {
			throw error
		}
	}

	private static func getKeystore() throws -> EthereumKeystoreV3 {
		// return keystore from memory
		if let keystore = shared._keystore {
			return keystore
		}

		// return keystore from file
		if let keystoreManager = try? getKeystoreManager(),
			let address = keystoreManager.addresses?.first,
			let retrievedKeystore = keystoreManager.walletForAddress(address) as? EthereumKeystoreV3 {
			shared._keystore = retrievedKeystore
			return retrievedKeystore
		}

		// create new keystore
		do {
			let newKeystore = try createNewKeystore()
			shared._keystore = newKeystore
			return newKeystore
		}
		catch {
			throw error
		}
	}

	static func getKeystoreManager() throws -> KeystoreManager {
		// return keystoreManager from memory
		if let keystoreManager = shared._keystoreManager,
			keystoreManager.addresses?.first != nil {
			return keystoreManager
		}

		// create new keystoreManager
		do {
			let newKeystoreManager = try createNewKeystoreManager()
			shared._keystoreManager = newKeystoreManager
			return newKeystoreManager
		}
		catch {
			throw error
		}
	}

	static func start() throws -> Void {
		// make sure to call this first so keystore and keystoreManager are created in correct order
		do {
			_ = try getKeystore()
			_ = try getKeystoreManager()
			shared._address = try getAddress()
		}
		catch {
			throw error
		}
	}

	static private func createNewKeystoreManager() throws -> KeystoreManager {
		guard let userDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
			let newKeystoreManager = KeystoreManager.managerForPath(userDirectory + "/keystore")
			else {
				throw ValletError.wallet(object: "KeystoreManager", function: #function)
		}
		return newKeystoreManager
	}

	static private func createNewKeystore() throws -> EthereumKeystoreV3 {
		do {
			guard let newKeystore = try EthereumKeystoreV3(password: Constants.Temp.keystorePassword)
				else {
					throw ValletError.wallet(object: "PrivateKey", function: #function)
			}
			shared._keystore = newKeystore
			
			let newKeystoreJSON = try JSONEncoder().encode(newKeystore.keystoreParams)
			let keystoreManager = try getKeystoreManager()
			FileManager.default.createFile(atPath: "\(keystoreManager.path)/keystore.json", contents: newKeystoreJSON, attributes: nil)

			shared._keystoreManager = try createNewKeystoreManager()

			return newKeystore
		} catch {
			print("Couldn't create and save a new Keystore. Error: \(error)")
			throw error
		}
	}

}
