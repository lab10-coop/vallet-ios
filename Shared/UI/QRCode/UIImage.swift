//
//  UIImage.swift
//  Vallet
//
//  Created by Matija Kregar on 11/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

	static func qrCode(from string: String, size: CGSize) -> UIImage? {
		guard let filter = CIFilter(name: "CIQRCodeGenerator")
			else {
				return nil
		}

		let data = string.data(using: String.Encoding.ascii)
		filter.setValue(data, forKey: "inputMessage")

		guard let qrCodeImage = filter.outputImage
			else {
				return nil
		}

		let scaleX = size.width * 3 / qrCodeImage.extent.size.width
		let scaleY = size.height * 3 / qrCodeImage.extent.size.height

		let resizedQRCodeImage = qrCodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

		return UIImage(ciImage: resizedQRCodeImage)
	}

}
