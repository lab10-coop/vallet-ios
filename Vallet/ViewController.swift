//
//  ViewController.swift
//  Vallet
//
//  Created by Matija Kregar on 05/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

	}

	@IBAction func showAddress(_ sender: Any? = nil) {
		ClientAddressViewController.present(over: self)
	}

}
