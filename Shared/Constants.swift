//
//  Constants.swift
//  Vallet
//
//  Created by Matija Kregar on 05/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

struct Constants {

	struct BlockChain {

		// TODO: move the addresses to the xcconfig file
		static let faucetServerAddress = "http://faucet.t1.artis.lab10.io/"
		static let nodeAddress = "http://rpc.t1.artis.lab10.io:10204/"
		static let tokenFactoryContractAddress = "0x0fd1fa8112f205d5c2754ece65eb43deb3592214"

		struct Event {

			static let tokenCreated = "TokenCreated"
			static let redeem = "Redeem"
			static let transfer = "Transfer"
			
		}
	}

	struct Timer {

		static let pollInterval: TimeInterval = 3.0
		static let maxRepeatCount = 20

	}

	// do not deploy with these values !!!
	struct Temp {

		static let keystorePassword = "ValletTEST"

	}

}
