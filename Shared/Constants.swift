//
//  Constants.swift
//  Vallet
//
//  Created by Matija Kregar on 05/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

struct Constants {

	struct Network {

		static let apiHost = "https://vallet.mars.lab10.io"

	}

	struct BlockChain {

		// TODO: move the addresses to the xcconfig file
		static let IPFSAddress = "http://ipfs.mars.lab10.io:5001/api/v0/"
		static let faucetServerAddress = "http://faucet.t1.artis.lab10.io/"
		static let nodeAddress = "http://rpc.t1.artis.lab10.io:10204/"
		static let tokenFactoryContractAddress = "0x0fd1fa8112f205d5c2754ece65eb43deb3592214"

		struct Event {

			static let tokenCreated = "TokenCreated"
			static let redeem = "Redeem"
			static let transfer = "Transfer"
			
		}
	}

	struct Notification {

		static let newValueEvent: NSNotification.Name = NSNotification.Name(rawValue: "Notification.newValueEvent")

	}

	struct Animation {

		static let shortDuration = 0.25
		static let longDuration = 0.7

	}

	struct Timer {

		static let pollInterval: TimeInterval = 3.0
		static let maxRepeatCount = 20

	}

	struct UserDefaultsKey {

		static let selectedShopAddress = "selectedShopAddress"
		static let userName = "userName"

	}

	// do not deploy with these values !!!
	struct Temp {

		static let keystorePassword = "ValletTEST"

	}

}
