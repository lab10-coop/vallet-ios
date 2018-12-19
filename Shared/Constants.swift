//
//  Constants.swift
//  Vallet
//
//  Created by Matija Kregar on 05/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import CoreGraphics

struct Constants {

	struct Deeplink {

		static let adminScheme = "valletadmin://"
		static let clientScheme = "vallet://"

		static let shop = "shop"
		static let user = "user"

		struct QueryKey {

			static let userName = "user_name"

		}

	}

	struct IPFS {

		static let address = "ipfs.mars.lab10.io"

	}

	struct BlockChain {

		// TODO: move the addresses to the xcconfig file
		static let faucetServerAddress = "http://faucet.tau1.artis.network/"
		static let nodeAddress = "http://rpc.tau1.artis.network"
		static let tokenFactoryContractAddress = "0xE8DF33A947c911D0E74D66d880e3de07aEd5023D"

		struct Event {

			static let tokenCreated = "TokenCreated"
			static let redeem = "Redeem"
			static let transfer = "Transfer"
			
		}
	}

	struct Notification {

		static let valueEventsUpdate: NSNotification.Name = NSNotification.Name(rawValue: "Notification.valueEventsUpdate")
		static let newValueEvent: NSNotification.Name = NSNotification.Name(rawValue: "Notification.newValueEvent")
		static let balanceRequest: NSNotification.Name = NSNotification.Name(rawValue: "Notification.balanceRequest")

	}

	struct Animation {

		static let shortDuration = 0.25
		static let defaultDuration = 0.4
		static let longDuration = 0.7

	}

	struct Timer {

		static let pollInterval: TimeInterval = 3.0
		static let maxRepeatCount = 20
		static let notificationDuration: TimeInterval = 3.0

	}

	struct UserDefaultsKey {

		static let selectedShopAddress = "selectedShopAddress"
		static let userName = "userName"

	}

	struct Image {

		static let jpegCompression: CGFloat = 0.7
		
	}

	struct Content {

		static let maxShopNameLength = 10
		static let productImageSize = CGSize(width: 500, height: 500)
		static let maxCurrencyDecimals = 2

	}

}
