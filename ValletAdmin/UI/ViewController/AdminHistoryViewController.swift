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
	@IBOutlet private var totalSupplyLabel: UILabel!

	private lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(reloadData), for: UIControl.Event.valueChanged)
		return refreshControl
	}()

	var historyViewModel: HistoryViewModel?
	var shop: Shop?
	weak var container: UIViewController?

	private var groupedEvents = [EventsGroup]()

	static func instance(for shop: Shop) -> AdminHistoryViewController? {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

		guard let adminHistoryViewController = storyboard.instantiateViewController(withIdentifier: "AdminHistoryViewController") as? AdminHistoryViewController
			else {
				return nil
		}

		adminHistoryViewController.shop = shop

		return adminHistoryViewController
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
		HistoryTableSectionHeaderView.register(for: tableView)
		HistoryTableSectionFooterView.register(for: tableView)

		tableView.addSubview(refreshControl)

		reloadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		historyViewModel?.updateEvents()
		reloadTableView()
		updateTotalSupply()
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

	private func updateTotalSupply() {
		guard let shop = shop
			else {
				return
		}
		ShopManager.totalSupply(for: shop) { [weak self] (result) in
			switch result {
			case .success(let balance):
				self?.totalSupplyLabel.text = balance.description
			case .failure(let error):
				print("Load total supply error: \(error)")
			}
		}
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
		return groupedEvents.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return groupedEvents[section].events.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: AdminHistoryEventTableViewCell.reuseIdentifier, for: indexPath)
		if let historyEventCell = cell as? AdminHistoryEventTableViewCell {
			historyEventCell.event = groupedEvents[indexPath.section].events[indexPath.row]
		}
		return cell
	}

}


// MARK: - Table view delegate

extension AdminHistoryViewController: UITableViewDelegate {

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

