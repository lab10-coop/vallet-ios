//
//  NibBackedTableViewCell.swift
//  Vallet
//
//  Created by Matija Kregar on 13/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

protocol NibBackedTableViewCell: class {

	static var nibName: String { get }
	static var nib: UINib { get }
	static var reuseIdentifier: String { get }

	static func register(for tableView: UITableView)

}

extension NibBackedTableViewCell where Self: UITableViewCell {

	static var nibName: String {
		return className
	}

	static var nib: UINib {
		return UINib(nibName: nibName, bundle: Bundle(for: self))
	}

	static var reuseIdentifier: String {
		return className
	}

	static func register(for tableView: UITableView) {
		tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
	}

}


