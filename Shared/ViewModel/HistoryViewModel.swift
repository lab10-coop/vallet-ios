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

struct EventsGroup {

	var date = Date()
	var events = [ValueEvent]()

}

class HistoryViewModel {

	var token: Token
	var shop: Shop
	var clientAddress: EthereumAddress?
	var managedObjectContext: NSManagedObjectContext?

	var events: [ValueEvent] = [ValueEvent]()

	var lastBlockNumber: UInt64 {
		guard let lastBlockNumber = events.last?.blockNumber
		else {
			return 0
		}
		return lastBlockNumber
	}

	var groupedEvents: [EventsGroup] {
		let calendar = Calendar.current

		let grouped = Dictionary(grouping: events, by: { (event) -> Date in
			guard let date = event.date
				else {
					return calendar.startOfDay(for: Date.distantPast)
			}
			return calendar.startOfDay(for: date)
		})

		var groups = grouped.map { (entry) -> EventsGroup in
			return EventsGroup(date: entry.key, events: entry.value)
		}
		groups.sort(by: { $0.date > $1.date })

		return groups
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

		updateEvents()
	}

	func reload(completion: @escaping (Result<[ValueEvent]>) -> Void) {
		token.loadHistory(for: clientAddress, fromBlock: lastBlockNumber) { [weak self] (eventsResult) in
			guard let strongSelf = self,
				let managedObjectContext = strongSelf.managedObjectContext
				else {
					completion(Result.failure(ValletError.unwrapping(property: "managedObjectContext", object: "HistoryViewModel", function: #function)))
					return
			}
			switch eventsResult {
			case .success(let eventsIntermediate):
				let loadedEvents = eventsIntermediate.compactMap { ValueEvent(in: managedObjectContext, shop: strongSelf.shop, intermediate: $0) }
				DataBaseManager.save(managedContext: managedObjectContext)
				strongSelf.updateEvents()
				completion(Result.success(loadedEvents))
			case .failure(let error):
				completion(Result.failure(error))
			}
		}
	}

	func updateEvents() {
		// update events from the database
		guard var updatedEvents = (try? managedObjectContext?.fetch(ValueEvent.fetchRequest())) as? [ValueEvent]
			else {
				return
		}
		updatedEvents = updatedEvents.filter({ $0.shop == shop }).sorted(by: { $0.blockNumber > $1.blockNumber })
		if updatedEvents.count != events.count {
			NotificationCenter.default.post(name: Constants.Notification.newValueEvent, object: nil)
		}

		events = updatedEvents

		attachUser(for: events)
		
		fetchDateFor(events: events) { (result) in
			print("Fetch date events result: \(result)")
		}
	}

	private func fetchDateFor(events: [ValueEvent], completion: @escaping (Result<Bool>) -> Void) {
		let events = events.filter { $0.date == nil }

		// TODO: Find a more elegant way of doing this.
		let allEvents = events.count
		var successCounter = 0
		var resultCounter = 0
		for event in events {
			Web3Manager.getBlock(by: event.blockHash) { (blockResult) in
				resultCounter += 1
				guard case .success(let block) = blockResult
				else {
					return
				}
				successCounter += 1
				event.date = block.timestamp
				if resultCounter == allEvents {
					let result = successCounter == allEvents ? Result.success(true) : Result.failure(ValletError.networkData(function: #function))
					completion(result)
				}
			}
		}
	}

	private func attachUser(for events: [ValueEvent]) {
		guard let managedObjectContext = managedObjectContext
			else {
				return
		}
		for event in events {
			if event.client == nil,
				let user = User.user(in: managedObjectContext, with: event.clientAddress) {
				event.client = user
			}
		}
		DataBaseManager.save(managedContext: managedObjectContext)
	}

}
