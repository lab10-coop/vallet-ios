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

		tableView.addSubview(refreshControl)

		reloadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		historyViewModel?.updateEvents()
		tableView.reloadData()
	}

	@objc private func reloadData() {
		historyViewModel?.reload(completion: { [weak self] (result) in
			guard case .success = result
				else {
					return
			}
			self?.refreshControl.endRefreshing()
			self?.tableView.reloadData()
		})
	}

}


// MARK: - Table view data source

extension ClientHistoryViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return historyViewModel?.events.count ?? 0
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

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}

}

