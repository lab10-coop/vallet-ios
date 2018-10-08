//
//  Label.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

class BodyLabel: BaseLabel {
	override var mode: LabelMode {
		return .normal
	}
	override var customFont: UIFont? {
		return Theme.Font.bodyFont
	}
}

class AccentedBodyLabel: BodyLabel {
	override var mode: LabelMode {
		return .accent
	}
}

class ErrorBodyLabel: BodyLabel {
	override var mode: LabelMode {
		return .error
	}
}

class LargeTextLabel: BaseLabel {
	override var mode: LabelMode {
		return .normal
	}
	override var customFont: UIFont? {
		return Theme.Font.largeTextFont
	}
}

class LargerTextLabel: BaseLabel {
	override var mode: LabelMode {
		return .normal
	}
	override var customFont: UIFont? {
		return Theme.Font.largerTextFont
	}
}

class SmallLightTextLabel: BaseLabel {
	override var mode: LabelMode {
		return .light
	}
	override var customFont: UIFont? {
		return Theme.Font.smallTextFont
	}
}

class SmallDarkTextLabel: BaseLabel {
	override var mode: LabelMode {
		return .normal
	}
	override var customFont: UIFont? {
		return Theme.Font.smallTextFont
	}
}

class NavigationBarTitleLabel: BaseLabel {
	override var mode: LabelMode {
		return .normal
	}
	override var customFont: UIFont? {
		return Theme.Font.navigationBarTitleFont
	}
}

class LargeTitleLabel: BaseLabel {
	override var mode: LabelMode {
		return .normal
	}
	override var customFont: UIFont? {
		return Theme.Font.largeTitleFont
	}
}

class TitleLabel: BaseLabel {
	override var mode: LabelMode {
		return .normal
	}
	override var customFont: UIFont? {
		return Theme.Font.titleFont
	}
}

class SmallDarkTitleLabel: BaseLabel {
	override var mode: LabelMode {
		return .normal
	}
	override var customFont: UIFont? {
		return Theme.Font.smallTitleFont
	}
}

class SmallLightTitleLabel: BaseLabel {
	override var mode: LabelMode {
		return .light
	}
	override var customFont: UIFont? {
		return Theme.Font.smallTitleFont
	}
}
