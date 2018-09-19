//
//  ClientHistoryTableViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 19/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class ClientHistoryTableViewController: UITableViewController {

	var historyViewModel: HistoryViewModel?
	var shop: Shop?

	static func present(for shop: Shop, over viewController: UIViewController) {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

		guard let clientHistoryTableViewController = storyboard.instantiateViewController(withIdentifier: "ClientHistoryTableViewController") as? ClientHistoryTableViewController
			else {
				return
		}

		clientHistoryTableViewController.shop = shop

		viewController.present(clientHistoryTableViewController, animated: false)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		guard let shop = shop
			else {
				return
		}

		historyViewModel = HistoryViewModel(shop: shop, clientAddress: Wallet.address)

		ClientHistoryEventTableViewCell.register(for: tableView)

		reloadData()
	}

	private func reloadData() {
		historyViewModel?.reload(completion: { [weak self] (result) in
			guard case .success = result
				else {
					return
			}
			self?.tableView.reloadData()
		})
	}

	@IBAction func close(_ sender: Any? = nil) {
		dismiss(animated: true, completion: nil)
	}

}


// MARK: - Table view data source

extension ClientHistoryTableViewController {

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return historyViewModel?.events.count ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ClientHistoryEventTableViewCell.reuseIdentifier, for: indexPath)
		if let historyEventCell = cell as? ClientHistoryEventTableViewCell {
			historyEventCell.event = historyViewModel?.events[indexPath.row]
		}
		return cell
	}

}


// MARK: - Table view delegate

extension ClientHistoryTableViewController {

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}

}

