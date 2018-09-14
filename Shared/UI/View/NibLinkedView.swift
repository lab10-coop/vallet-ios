//
//  NibLinkedView.swift
//  Vallet
//
//  Created by Matija Kregar on 11/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

public class NibLinkedView: UIView {

	var view: UIView!

	// MARK: - Lifecycle

	public override init(frame: CGRect) {
		super.init(frame: frame)
		xibSetup()
		setup()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		xibSetup()
		setup()
	}

	// MARK: - Initial setup

	public func setup() {
		// override in a subclass if needed
	}

	private func xibSetup() {
		guard let loadedView = loadViewFromXib()
			else {
				fatalError("View cannot be loaded from Xib. Check the file names!")
		}
		view = loadedView
		view.frame = self.bounds
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.addSubview(view)
	}

	private func loadViewFromXib() -> UIView? {
		let nibName = String(describing: type(of: self))
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: nibName, bundle: bundle)
		guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
			else {
				return nil
		}
		return view
	}
}

