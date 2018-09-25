//
//  ScaledFont.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import UIKit

public final class ScaledFont {

	private struct FontDescription: Decodable {
		let fontSize: CGFloat
		let fontName: String
	}

	private typealias StyleDictionary = [UIFontTextStyle.RawValue: FontDescription]
	private var styleDictionary: StyleDictionary?

	public init(fontName: String? = nil) {
		// If a resource with the name can be parsed, its settings will be used.
		guard let fontName = fontName,
			let url = Bundle.main.url(forResource: fontName, withExtension: "plist"),
			let data = try? Data(contentsOf: url)
			else {
				return
		}
		let decoder = PropertyListDecoder()
		styleDictionary = try? decoder.decode(StyleDictionary.self, from: data)
	}

	public func font(for textStyle: UIFontTextStyle) -> UIFont {
		// If custom settings parsing failed, system font/style mapping is used.
		guard let fontDescription = styleDictionary?[textStyle.rawValue],
			let font = UIFont(name: fontDescription.fontName, size: fontDescription.fontSize)
			else {
				return UIFont.preferredFont(forTextStyle: textStyle)
		}
		let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
		return fontMetrics.scaledFont(for: font)
	}
}
