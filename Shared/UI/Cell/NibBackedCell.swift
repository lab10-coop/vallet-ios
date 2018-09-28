//
//  NibBackedTableViewCell.swift
//  Vallet
//
//  Created by Matija Kregar on 13/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

protocol NibBackedCell: class {

	static var nibName: String { get }
	static var nib: UINib { get }
	static var reuseIdentifier: String { get }

}

extension NibBackedCell where Self: UIView {

	static var nibName: String {
		return className
	}

	static var nib: UINib {
		return UINib(nibName: nibName, bundle: Bundle(for: self))
	}

	static var reuseIdentifier: String {
		return className
	}

}

protocol NibBackedTableViewCell: NibBackedCell {

	static func register(for tableView: UITableView)

}

extension NibBackedTableViewCell where Self: UITableViewCell {

	static func register(for tableView: UITableView) {
		tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
	}

}

protocol NibBackedCollectionViewCell: NibBackedCell {

	static func register(for collectionView: UICollectionView)

}

extension NibBackedCollectionViewCell where Self: UICollectionViewCell {

	static func register(for collectionView: UICollectionView) {
		collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
	}

}

protocol NibBackedTableHeaderFooterView: NibBackedCell {

	static func register(for tableView: UITableView)

}

extension NibBackedTableHeaderFooterView where Self: UITableViewHeaderFooterView {

	static func register(for tableView: UITableView) {
		tableView.register(nib, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
	}

}


