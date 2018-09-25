//
//  Theme.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

struct Theme {

	struct Font {

		static let fontName = "Work Sans"
		static let scaledFont: ScaledFont = ScaledFont(fontName: fontName)

		//MARK - Computed fonts

		static var largeTitleFont: UIFont {
			return scaledFont.font(for: .title1)
		}

		static var titleFont: UIFont {
			return scaledFont.font(for: .title2)
		}

		static var smallTitleFont: UIFont {
			return scaledFont.font(for: .title3)
		}

		static var navigationBarTitleFont: UIFont {
			return largeTitleFont
		}

		static var largeButtonFont: UIFont {
			return largeTitleFont
		}

		static var smallButtonFont: UIFont {
			return smallTitleFont
		}

		static var largeTextFont: UIFont {
			return scaledFont.font(for: .headline)
		}

		static var largerTextFont: UIFont {
			return scaledFont.font(for: .subheadline)
		}

		static var smallTextFont: UIFont {
			return scaledFont.font(for: .footnote)
		}

		static var bodyFont: UIFont {
			return scaledFont.font(for: .body)
		}

		static var inputFieldFont: UIFont {
			return scaledFont.font(for: .callout)
		}

		static var inputFieldTitleFont: UIFont {
			return smallTitleFont
		}
		
	}

}
