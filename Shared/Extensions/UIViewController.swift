//
//  UIViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 14/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

extension UIViewController {

	@discardableResult
	func showActivityIndicator(completion: (() -> Void)? = nil) -> UIView? {
		guard view.subviews.filter({ $0 is ActivityIndicatorView }).count == 0
			else {
				return nil
		}

		let activityIndicatorView = ActivityIndicatorView(frame: view.bounds)
		activityIndicatorView.alpha = 0
		view.addSubview(activityIndicatorView)

		activityIndicatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		activityIndicatorView.fadeIn(completion: { _ in
			completion?()
		})

		return activityIndicatorView
	}

	func hideActivityIndicator(completion: (() -> Void)? = nil) {
		view.subviews.filter({ $0 is ActivityIndicatorView }).forEach { subview in
			subview.fadeOut(completion: { _ in
				subview.removeFromSuperview()
			})
		}

		completion?()
	}

}
