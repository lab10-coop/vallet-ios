//
//  ViewController.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 05/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit
import web3swift

class ViewController: UIViewController {

	let testShopAddress = "0x0d1625c749C0115D62161fEa94F122BC2fe82297"
	let testClientAddress = "0x58d7dEEEB82a71Bf32aA1F55F8F52D4c261f08e8"

	let tokenFactory = TokenFactory(address: EthereumAddress(Constants.BlockChain.tokenFactoryContractAddress)!)

	override func viewDidLoad() {
		super.viewDidLoad()

		print("address: \(Wallet.address)")

		FaucetManager.getFunds(for: Wallet.address) { _ in }

//		tokenFactory.createShop(with: Wallet.address, name: "iOS-Test", type: .voucher) { result in
//			switch result {
//			case .success(let shop):
//				print("created shop: \(shop)")
//			case .failure(let error):
//				print("create shop error: \(error)")
//			}
//		}

//		tokenFactory.loadAllCreatedShops(for: Wallet.address) { (result) in
//			switch result {
//			case .success(let shops):
//				if let shops = shops {
//					print("all shops:")
//					shops.forEach {print($0)}
//				}
//			case .failure(let error):
//				print("load shops error: \(error)")
//			}
//		}

		guard let shopAddress = EthereumAddress(testShopAddress),
		let clientAddress = EthereumAddress(testClientAddress)
			else {
				return
		}

		let token = Token(address: shopAddress)
		token.issue(value: 1, to: clientAddress, from: Wallet.address) { (result) in
			switch result {
			case .success(let transactionSendingResult):
				print("issue transaction result: \(transactionSendingResult)")
			case .failure(let error):
				print("issue transaction error: \(error)")
			}
		}

	}

}

