//
//  MainViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 21/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

	@IBOutlet var contentSegmentedView: SegmentedControlView!
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

		setupMenu()
		contentSegmentedView.delegate = self

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
		contentSegmentedView.selectedIndex = selectedIndex
	}

	private func updatePageViewContoller(direction: UIPageViewController.NavigationDirection) {
		guard selectedIndex < viewControllers.count
			else {
				return
		}
		let viewController = viewControllers[selectedIndex]

		pageViewController?.setViewControllers([viewController], direction: direction, animated: true, completion: { (success) in
		})
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

extension MainViewController: SegmentedControlViewDelegate {

	func didChangeSelected(to index: Int) {
		guard index != selectedIndex
			else {
				return
		}

		let direction: UIPageViewController.NavigationDirection = selectedIndex < index ? .forward : .reverse
		selectedIndex = index

		updatePageViewContoller(direction: direction)
	}

}

