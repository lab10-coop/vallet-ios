//
//  ViewController.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 05/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	let tokenFactory = TokenFactory()

	override func viewDidLoad() {
		super.viewDidLoad()

//		tokenFactory.createShop(with: Wallet.address, name: "iOS-Test", type: .voucher) { result in
//			switch result {
//			case .success(let shop):
//				print("created shop: \(shop)")
//			case .failure(let error):
//				print("create shop error: \(error)")
//			}
//		}

		tokenFactory.loadAllCreatedShops(for: Wallet.address) { (result) in
			switch result {
			case .success(let shops):
				if let shops = shops {
					print("all shops:")
					shops.forEach {print($0)}
				}
			case .failure(let error):
				print("load shops error: \(error)")
			}
		}

	}

}

