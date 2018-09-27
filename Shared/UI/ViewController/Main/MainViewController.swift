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
	@IBOutlet var dropMenuIconView: UIImageView!
	@IBOutlet var clientBalanceLabel: UILabel!
	@IBOutlet var qrCodeButton: UIButton!

	var pageViewController: UIPageViewController?
	var viewControllers = [UIViewController]()

	var shop: Shop? {
		didSet {
			setupContent(for: shop)
		}
	}

	var selectedIndex: Int = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		dropMenuIconView.tintColor = Theme.Color.navigationBarButton

		shopNameLabel.text = ""
		clientBalanceLabel.text = ""

		self.shop = ShopManager.selectedShop
	}

	static func makeAppRootViewController() {
		let storyboard = UIStoryboard(name: "Shared", bundle: Bundle.main)
		guard let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController,
			let appDelegate = UIApplication.shared.delegate as? AppDelegate
			else {
				return
		}

		appDelegate.window?.rootViewController = mainViewController
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

	private func updateSegmentedControl() {
		contentSegmentedControl.selectedSegmentIndex = selectedIndex
	}

	private func updatePageViewContoller(direction: UIPageViewControllerNavigationDirection) {
		guard selectedIndex < viewControllers.count
			else {
				return
		}
		let viewController = viewControllers[selectedIndex]

		pageViewController?.setViewControllers([viewController], direction: direction, animated: true, completion: { (success) in
		})
	}

	@IBAction func didChangeContent(_ sender: Any? = nil) {
		guard contentSegmentedControl.selectedSegmentIndex != selectedIndex
			else {
				return
		}

		let direction: UIPageViewControllerNavigationDirection = selectedIndex < contentSegmentedControl.selectedSegmentIndex ? .forward : .reverse
		selectedIndex = contentSegmentedControl.selectedSegmentIndex

		updatePageViewContoller(direction: direction)
	}

	@IBAction func shopShopMenu(_ sender: Any? = nil) {
		let shopMenuViewController = ShopMenuViewController.present(over: self)
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
		selectedIndex = currentIndex - 1
		return viewControllers[selectedIndex]
	}

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let currentIndex = viewControllers.index(of: viewController),
			currentIndex + 1 < viewControllers.count
			else {
				return nil
		}
		selectedIndex = currentIndex + 1
		return viewControllers[selectedIndex]
	}

}

extension MainViewController: UIPageViewControllerDelegate {

	func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
		if let pendingViewController = pendingViewControllers.first,
			let pendingIndex = viewControllers.index(of: pendingViewController) {
			selectedIndex = pendingIndex
		}
	}

	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if completed {
			updateSegmentedControl()
		}
	}

}

extension MainViewController: ShopMenuDelegate {

	func didSelect(shop: Shop) {
		self.shop = shop
	}

}

