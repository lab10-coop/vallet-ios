//
//  ClientHistoryViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 19/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class ClientHistoryViewController: UIViewController {

	@IBOutlet private var tableView: UITableView!

	private lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(reloadData), for: UIControlEvents.valueChanged)
		return refreshControl
	}()

	var historyViewModel: HistoryViewModel?
	var shop: Shop?
	weak var container: UIViewController?

	private var groupedEvents = [EventsGroup]()

	static func instance(for shop: Shop) -> ClientHistoryViewController? {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

		guard let clientHistoryViewController = storyboard.instantiateViewController(withIdentifier: "ClientHistoryViewController") as? ClientHistoryViewController
			else {
				return nil
		}

		clientHistoryViewController.shop = shop

		return clientHistoryViewController
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		guard let shop = shop
			else {
				return
		}

		historyViewModel = HistoryViewModel(shop: shop, clientAddress: Wallet.address)

		ClientHistoryEventTableViewCell.register(for: tableView)
		HistoryTableSectionHeaderView.register(for: tableView)

		tableView.addSubview(refreshControl)

		reloadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		reloadTableView()
	}

	private func reloadTableView() {
		historyViewModel?.updateEvents()
		guard let groupedEvents = historyViewModel?.groupedEvents
			else {
				return
		}
		self.groupedEvents = groupedEvents
		tableView.reloadData()
	}

	@objc private func reloadData() {
		historyViewModel?.reload(completion: { [weak self] (result) in
			guard case .success = result
				else {
					return
			}
			self?.refreshControl.endRefreshing()
			self?.reloadTableView()
		})
	}

}


// MARK: - Table view data source

extension ClientHistoryViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return groupedEvents.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return groupedEvents[section].events.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ClientHistoryEventTableViewCell.reuseIdentifier, for: indexPath)
		if let historyEventCell = cell as? ClientHistoryEventTableViewCell {
			historyEventCell.event = historyViewModel?.events[indexPath.row]
		}
		return cell
	}

}


// MARK: - Table view delegate

extension ClientHistoryViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HistoryTableSectionHeaderView.reuseIdentifier)
		if let historyHeaderView = headerView as? HistoryTableSectionHeaderView {
			historyHeaderView.date = groupedEvents[section].date
		}
		return headerView
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}

}

