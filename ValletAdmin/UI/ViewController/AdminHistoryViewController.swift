//
//  AdminHistoryViewController.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 19/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class AdminHistoryViewController: UIViewController {

	@IBOutlet private var tableView: UITableView!

	var historyViewModel: HistoryViewModel?
	var shop: Shop?
	weak var container: UIViewController?

	static func instance(for shop: Shop) -> AdminHistoryViewController? {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

		guard let adminHistoryTableViewController = storyboard.instantiateViewController(withIdentifier: "AdminHistoryViewController") as? AdminHistoryViewController
			else {
				return nil
		}

		adminHistoryTableViewController.shop = shop

		return adminHistoryTableViewController
	}

	static func present(for shop: Shop, over viewController: UIViewController) {
		guard let adminHistoryTableViewController = instance(for: shop)
			else {
				return
		}

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

	override func viewWillAppear(_ animated: Bool) {
		historyViewModel?.updateEvents()
		tableView.reloadData()
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

	@IBAction func sendMoney(_ sender: Any? = nil) {
		guard let shop = shop,
			let container = container
			else {
				return
		}
		IssueAddressViewController.present(for: shop, over: container)
	}

}


// MARK: - Table view data source

extension AdminHistoryViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return historyViewModel?.events.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: AdminHistoryEventTableViewCell.reuseIdentifier, for: indexPath)
		if let historyEventCell = cell as? AdminHistoryEventTableViewCell {
			historyEventCell.event = historyViewModel?.events[indexPath.row]
		}
		return cell
	}

}


// MARK: - Table view delegate

extension AdminHistoryViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

	}

}


