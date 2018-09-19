//
//  HistoryViewModel.swift
//  Vallet
//
//  Created by Matija Kregar on 18/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import web3swift
import CoreData

class HistoryViewModel {

	var token: Token
	var shop: Shop
	var clientAddress: EthereumAddress?
	var managedObjectContext: NSManagedObjectContext?

	var events: [ValueEvent] {
		// return events from the database
		guard let events = (try? managedObjectContext?.fetch(ValueEvent.fetchRequest())) as? [ValueEvent]
			else {
				return [ValueEvent]()
		}
		return events.filter { $0.shop == shop }
	}

	init?(shop: Shop, clientAddress: EthereumAddress? = nil) {
		guard let shopAddress = shop.address,
			let shopEthAddress = EthereumAddress(shopAddress)
			else {
				return nil
		}
		self.shop = shop
		self.managedObjectContext = shop.managedObjectContext
		self.token = Token(address: shopEthAddress)
		self.clientAddress = clientAddress
	}

	func reload(completion: @escaping (Result<[ValueEvent]>) -> Void) {
		token.loadHistory(for: clientAddress) { [weak self] (eventsResult) in
			guard let strongSelf = self,
				let managedObjectContext = strongSelf.managedObjectContext
				else {
					completion(Result.failure(Web3Error.unknownError))
					return
			}
			switch eventsResult {
			case .success(let eventsIntermediate):
				let loadedEvents = eventsIntermediate.compactMap { ValueEvent(in: managedObjectContext, shop: strongSelf.shop, intermediate: $0) }
				DataBaseManager.save(managedContext: managedObjectContext)
				completion(Result.success(loadedEvents))
			case .failure(let error):
				print("Load history error: \(error)")
			}
		}
	}

}
