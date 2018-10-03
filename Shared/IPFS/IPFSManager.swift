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
import web3swift

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
		guard let api = shared.api,
		let dataHash = Multihash.from(hashString: hash)
			else {
				completion(Result.failure(Web3Error.dataError))
				return
		}

		do {
			try api.get(dataHash) { (dataArray) in
				let imageData = Data(bytes: dataArray)
				guard let image = UIImage.init(data: imageData)
					else {
						completion(Result.failure(Web3Error.dataError))
						return
				}
				completion(Result.success(image))
			}
		}
		catch {
			print("IPFSManager load image error: \(error.localizedDescription)")
			completion(Result.failure(error))
		}
	}

	static func upload(image: UIImage, completion: @escaping (Result<String>) -> Void) {
		guard let imageData = image.jpegData(compressionQuality: Constants.Image.jpegCompression)
			else {
				completion(Result.failure(Web3Error.dataError))
				return
		}
		upload(data: imageData, completion: completion)
	}

	static func upload(data: Data, completion: @escaping (Result<String>) -> Void) {
		guard let api = shared.api
			else {
				completion(Result.failure(Web3Error.unknownError))
				return
		}
		do {
			try api.add(data) { (merkleArray) in
				guard let merkleNode = merkleArray.first,
					let hashString = merkleNode.hashString
					else {
						completion(Result.failure(Web3Error.dataError))
						return
				}
				completion(Result.success(hashString))
			}
		}
		catch {
			print("IPFSManager add error: \(error.localizedDescription)")
			completion(Result.failure(error))
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

	static func from(hashString: String) -> Multihash? {
		return try? SwiftMultihash.fromB58String(hashString)
	}

}
