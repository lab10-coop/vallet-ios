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
	@IBOutlet private var totalSupplyContainerView: UIView!
	@IBOutlet private var dashboardContainerView: UIView!
	@IBOutlet private var monthsGraphView: MonthsGraphView!
	@IBOutlet private var outgoingTitleLabel: UILabel!
	@IBOutlet private var outgoingValueLabel: UILabel!
	@IBOutlet private var incomingTitleLabel: UILabel!
	@IBOutlet private var incomingValueLabel: UILabel!
	@IBOutlet private var totalSupplyActivityIndicator: DotsActivityIndicator!

	private lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(reloadData), for: UIControl.Event.valueChanged)
		return refreshControl
	}()

	var historyViewModel: HistoryViewModel?
	var shop: Shop?
	weak var container: UIViewController?

	private var groupedEvents = [EventGroupable]()

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
		historyViewModel?.newDataBlock = { [weak self] in
			self?.refreshControl.endRefreshing()
			self?.reloadView()
		}

		AdminHistoryEventTableViewCell.register(for: tableView)
		HistoryTableSectionHeaderView.register(for: tableView)
		HistoryTableSectionFooterView.register(for: tableView)

		tableView.addSubview(refreshControl)

		totalSupplyContainerView.addShadow()
		totalSupplyContainerView.addRoundedCorners()

		dashboardContainerView.addShadow()
		dashboardContainerView.addRoundedCorners()

		outgoingTitleLabel.textColor = Theme.Color.outgoingGraph
		incomingTitleLabel.textColor = Theme.Color.incomingGraph

		reloadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		historyViewModel?.updateEvents()
		reloadView()
		updateTotalSupply()
	}

	private func reloadView() {
		guard let historyViewModel = historyViewModel
			else {
				return
		}
		self.groupedEvents = historyViewModel.groupedEvents
		tableView.reloadData()

		monthsGraphView.monthsData = historyViewModel.dashboardMonths(preceedingCount: 5)

		incomingValueLabel.text = CurrencyFormatter.displayString(for: historyViewModel.incomingSum)
		outgoingValueLabel.text = CurrencyFormatter.displayString(for: historyViewModel.outgoingSum)

		// Temporarily display total supply value calculated from events.
		totalSupplyLabel.text = CurrencyFormatter.displayString(for: (historyViewModel.outgoingSum - historyViewModel.incomingSum))

		updateTotalSupply()
	}

	@objc private func reloadData() {
		showTotalSupplyActivityIndicator()
		historyViewModel?.reload()
	}

	private func showTotalSupplyActivityIndicator() {
		totalSupplyActivityIndicator.startAnimating()
		UIView.animate(withDuration: Constants.Animation.defaultDuration) {
			self.totalSupplyLabel.alpha = Theme.Constants.loadingValueLabelAlpha
		}
	}

	private func hideTotalSupplyActivityIndicator() {
		totalSupplyActivityIndicator.stopAnimating()
		UIView.animate(withDuration: Constants.Animation.defaultDuration) {
			self.totalSupplyLabel.alpha = 1
		}
	}

	private func updateTotalSupply() {
		guard let shop = shop
			else {
				return
		}

		showTotalSupplyActivityIndicator()

		ShopManager.totalSupply(for: shop) { [weak self] (result) in
			switch result {
			case .success(let balance):
				self?.totalSupplyLabel.text = CurrencyFormatter.displayString(for: balance)
			case .failure(let error):
				NotificationView.drop(error: error)
			}
			self?.hideTotalSupplyActivityIndicator()
		}
	}

	@IBAction func sendMoney(_ sender: Any? = nil) {
		guard let shop = shop,
			let container = container
			else {
				return
		}
		let issueAddressViewController = IssueAddressViewController.present(for: shop, over: container)
		issueAddressViewController?.delegate = self
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
			let eventGroup = groupedEvents[section]
			if let datedEventsGroup = eventGroup as? DatedEventsGroup {
				historyHeaderView.date = datedEventsGroup.date
			}
			else if let describableEventsGroup = eventGroup as? DescribableEventsGroup {
				historyHeaderView.title = describableEventsGroup.description
			}
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


// MARK: - Issue delegate

extension AdminHistoryViewController: IssueViewControllerDelegate {

	func didIssueAmount(with pendingValueEvent: PendingValueEvent) {
		PendingEventManager.makeValueEvent(from: pendingValueEvent) { (result) in
			switch result {
			case .success:
				break
			case .failure(let error):
				NotificationView.drop(error: error)
			}
		}
	}

}
