//
//  Appearance.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

struct Appearance {

	static func setup() {
		BackgroundView.appearance().backgroundColor = Theme.Color.background
		ContentBackgroundView.appearance().backgroundColor = Theme.Color.contentBackground
		SeparatorView.appearance().backgroundColor = Theme.Color.separator

		UITableView.appearance().backgroundColor = Theme.Color.background
		UICollectionView.appearance().backgroundColor = Theme.Color.background
	}

}
