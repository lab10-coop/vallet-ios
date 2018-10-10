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
		refreshControl.addTarget(self, action: #selector(reloadData), for: UIControl.Event.valueChanged)
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
		historyViewModel?.newDataBlock = { [weak self] in
			self?.refreshControl.endRefreshing()
			self?.reloadTableView()
		}

		ClientHistoryEventTableViewCell.register(for: tableView)
		HistoryTableSectionHeaderView.register(for: tableView)
		HistoryTableSectionFooterView.register(for: tableView)

		tableView.addSubview(refreshControl)

		reloadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		reloadTableView()
	}

	private func reloadTableView() {
		guard let groupedEvents = historyViewModel?.groupedEvents
			else {
				return
		}
		self.groupedEvents = groupedEvents
		tableView.reloadData()
	}

	@objc private func reloadData() {
		historyViewModel?.reload()
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
			historyEventCell.event = groupedEvents[indexPath.section].events[indexPath.row]
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

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HistoryTableSectionFooterView.reuseIdentifier)
		return footerView
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}

}

