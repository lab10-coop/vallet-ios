//
//  IPFSManager.swift
//  Vallet
//
//  Created by Matija Kregar on 02/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit
import SwiftIpfsApi
import SwiftMultihash
import SwiftHex

class IPFSManager {

	private var api: IpfsApi?

	private static let shared = IPFSManager()

	init() {
		do {
			self.api = try IpfsApi(host: Constants.IPFS.address, port: 5001)
		} catch {
			print("IPFSManager init error: \(error.localizedDescription)")
		}
	}

	static func loadImage(hash: String, completion: @escaping (Result<UIImage>) -> Void) {
		loadData(hash: hash) { (result) in
			switch result {
			case .success(let imageData):
				guard let image = UIImage(data: imageData)
					else {
						completion(Result.failure(ValletError.dataDecoding(object: "image", function: #function)))
						return
				}
				completion(Result.success(image))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}
	
	static func loadData(hash: String, completion: @escaping (Result<Data>) -> Void) {
		guard let api = shared.api
			else {
				completion(Result.failure(ValletError.unwrapping(property: "api", object: "IPFSManager", function: #function)))
				return
		}
		do {
			let dataHash = try Multihash.from(hashString: hash)
			try api.get(dataHash) { (dataArray) in
				DispatchQueue.main.async {
					let imageData = Data(bytes: dataArray)
					completion(Result.success(imageData))
				}
			}
		}
		catch {
			completion(Result.failure(error))
		}
	}

	static func upload(image: UIImage, completion: @escaping (Result<String>) -> Void) {
		guard let imageData = image.jpegData(compressionQuality: Constants.Image.jpegCompression)
			else {
				completion(Result.failure(ValletError.dataEncoding(object: "image", function: #function)))
				return
		}
		upload(data: imageData, completion: completion)
	}

	static func upload(data: Data, completion: @escaping (Result<String>) -> Void) {
		guard let api = shared.api
			else {
				completion(Result.failure(ValletError.unwrapping(property: "api", object: "IPFSManager", function: #function)))
				return
		}
		do {
			try api.add(data) { (merkleArray) in
				DispatchQueue.main.async {
					guard let merkleNode = merkleArray.first,
						let hashString = merkleNode.hashString
						else {
							completion(Result.failure(ValletError.dataDecoding(object: "hashString", function: #function)))
							return
					}
					completion(Result.success(hashString))
				}
			}
		}
		catch {
			DispatchQueue.main.async {
				completion(Result.failure(error))
			}
		}
	}

}

extension MerkleNode {

	var hashString: String? {
		guard let hash = hash
			else {
				return nil
		}
		return SwiftMultihash.b58String(hash)
	}

}

extension Multihash {

	static func from(hashString: String) throws -> Multihash {
		do {
			return try SwiftMultihash.fromB58String(hashString)
		}
		catch {
			throw error
		}
	}

}
