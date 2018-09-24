//
//  MainViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 21/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

	@IBOutlet var contentSegmentedControl: UISegmentedControl!
	@IBOutlet var containerView: UIView!
	@IBOutlet var shopNameLabel: UILabel!

	var pageViewController: UIPageViewController?
	var viewControllers = [UIViewController]()

	var shop: Shop? {
		didSet {
			guard let shop = shop
				else {
					return
			}
			setupContent(for: shop)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.shop = ShopManager.selectedShop
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case "EmbedContentSegue":
			guard let embededViewController = segue.destination as? UIPageViewController
				else {
					return
			}
			embededViewController.delegate = self
			embededViewController.dataSource = self
			pageViewController = embededViewController
		default:
			break
		}
	}

	@IBAction func didChangeContent(_ sender: Any? = nil) {
		print("change content")
	}

	@IBAction func shopShopMenu(_ sender: Any? = nil) {
		let shopMenuViewController = SideMenuViewController.present(over: self)
		shopMenuViewController?.delegate = self
	}

}

extension MainViewController: UIPageViewControllerDataSource {

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let currentIndex = viewControllers.index(of: viewController),
			currentIndex - 1 >= 0
			else {
				return nil
		}
		let prevIndex = currentIndex - 1
		return viewControllers[prevIndex]
	}

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let currentIndex = viewControllers.index(of: viewController),
			currentIndex + 1 < viewControllers.count
			else {
				return nil
		}
		let nextIndex = currentIndex + 1
		return viewControllers[nextIndex]
	}

}

extension MainViewController: UIPageViewControllerDelegate {

}

extension MainViewController: SideMenuDelegate {

	func didSelect(shop: Shop) {
		self.shop = shop
	}

}

