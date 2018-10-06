//
//  PrivacyPermissionsManager.swift
//  Vallet
//
//  Created by Matija Kregar on 06/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

enum PrivacyPermissionType {
	case camera
	case photoLibrary
}

class PrivacyPermissionsManager {

	static func getPermission(for type: PrivacyPermissionType, completion: @escaping (PrivacyPermissionType, Bool) -> Void) {
		switch type {

		case .camera:
			let status = AVCaptureDevice.authorizationStatus(for: .video)
			switch status {
			case .authorized:
				completion(type, true)
			case .denied, .restricted:
				completion(type, false)
			case .notDetermined:
				AVCaptureDevice.requestAccess(for: .video) { (granted: Bool) in
					completion(type, granted)
				}
			}

		case .photoLibrary:
			let status = PHPhotoLibrary.authorizationStatus()
			switch status {
			case .authorized:
				completion(type, true)
			case .denied, .restricted:
				completion(type, false)
			case .notDetermined:
				PHPhotoLibrary.requestAuthorization { (newStatus) in
					completion(type, newStatus == .authorized)
				}
			}
		}
	}

	static func presentSettingsAlert(for type: PrivacyPermissionType, in viewController: UIViewController) {
		let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: "Permission alert action"), style: .default) { _ in
			guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
				else {
					return
			}
			UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
		}
		let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
		var title = ""
		switch type {
		case .camera:
			title = NSLocalizedString("Camera Access Denied.", comment: "Permission alert title")
		case .photoLibrary:
			title = NSLocalizedString("Photo Library Access Denied.", comment: "Permission alert title")
		}
		let message = NSLocalizedString("Please go to app settings and allow access.", comment: "Permission alert message")

		viewController.presentAlert(title: title, message: message, actions: [settingsAction, cancelAction])
	}

}
