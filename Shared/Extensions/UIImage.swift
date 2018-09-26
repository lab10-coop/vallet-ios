//
//  UIImage.swift
//  Vallet
//
//  Created by Matija Kregar on 25/09/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

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

	func tinted(with color:UIColor) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
		guard let context = UIGraphicsGetCurrentContext(),
			let cgImage = cgImage
			else {
				return nil
		}

		color.setFill()

		context.translateBy(x: 0, y: size.height)
		context.scaleBy(x: 1.0, y: -1.0)

		let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
		context.draw(cgImage, in: rect)

		context.setBlendMode(CGBlendMode.sourceIn)
		context.addRect(rect)
		context.drawPath(using: CGPathDrawingMode.fill)

		let coloredImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
		UIGraphicsEndImageContext()

		return coloredImage
	}

}
