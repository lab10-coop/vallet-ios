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

		UIButton.appearance().tintColor = Theme.Color.navigationBarButton
		UITextField.appearance().tintColor = Theme.Color.accent

		UINavigationBar.appearance().backgroundColor = Theme.Color.navigationBar
		UINavigationBar.appearance().barTintColor = Theme.Color.navigationBar
		UINavigationBar.appearance().tintColor = Theme.Color.navigationBarButton
		UINavigationBar.appearance().shadowImage = UIImage()
		UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
		UINavigationBar.appearance().isTranslucent = true
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.Color.darkText, NSAttributedString.Key.font: Theme.Font.largeTitleFont]
	}

}
