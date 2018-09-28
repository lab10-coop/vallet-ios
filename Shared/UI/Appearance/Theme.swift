//
//  Theme.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

struct Theme {

	struct Constants {

		static let cornerRadius: CGFloat = 6.0
		static let shadowRadius: CGFloat = 5.0

	}

	// MARK: - Colors

	struct Color {

		static let navigationBar = UIColor.clear
		static let navigationBarButton = UIColor(red:0.61, green:0.62, blue:0.63, alpha:1.0) //#9B9EA0

		static let lightText = UIColor(red:0.61, green:0.62, blue:0.63, alpha:1.0) //#9B9EA0
		static let darkText = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0) //#333333

		static let accent = UIColor(red:0.04, green:0.62, blue:0.98, alpha:1.0) //#0A9FFA
		static let error = UIColor(red:0.85, green:0.02, blue:0.20, alpha:1.0) //#D90634

		static let separator = UIColor(red:0.90, green:0.91, blue:0.92, alpha:1.0) //#E5E8EB
		static let contentBackground = UIColor.white
		static let background = UIColor(red:0.98, green:0.98, blue:0.99, alpha:1.0) //#FAFBFC

		static let accentGradientStart = UIColor(red:0.00, green:0.75, blue:0.99, alpha:1.0) //#00C0FD
		static let accentGradientEnd = UIColor(red:0.13, green:0.29, blue:0.95, alpha:1.0) //#224AF2

		static let defaultButtonBackground = UIColor.clear
		static let defaultButtonContent = accent

		static let largeButtonContent = UIColor.white

	}

	// MARK: - Fonts

	struct Font {

		static let fontName = "Work Sans"
		static let scaledFont: ScaledFont = ScaledFont(fontName: fontName)

		// MARK: - Computed fonts

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
