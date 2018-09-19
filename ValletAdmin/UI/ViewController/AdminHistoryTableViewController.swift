//
//  AdminHistoryTableViewController.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 19/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class AdminHistoryTableViewController: UITableViewController {

	var historyViewModel: HistoryViewModel?
	var shop: Shop?

	static func present(for shop: Shop, over viewController: UIViewController) {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

		guard let adminHistoryTableViewController = storyboard.instantiateViewController(withIdentifier: "AdminHistoryTableViewController") as? AdminHistoryTableViewController
			else {
				return
		}

		adminHistoryTableViewController.shop = shop

		viewController.present(adminHistoryTableViewController, animated: false)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		guard let shop = shop
			else {
				return
		}

		historyViewModel = HistoryViewModel(shop: shop)

		AdminHistoryEventTableViewCell.register(for: tableView)

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

extension AdminHistoryTableViewController {

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return historyViewModel?.events.count ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: AdminHistoryEventTableViewCell.reuseIdentifier, for: indexPath)
		if let historyEventCell = cell as? AdminHistoryEventTableViewCell {
			historyEventCell.event = historyViewModel?.events[indexPath.row]
		}
		return cell
	}

}


// MARK: - Table view delegate

extension AdminHistoryTableViewController {

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

	}

}


