//
//  ErrorNotificationView.swift
//  Vallet
//
//  Created by Matija Kregar on 09/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

extension NotificationView {

	static func drop(error: Error) {
		var title = "Error"
		
		if let valletError = error as? ValletError {
			title = valletError.localizedNotificationTitle
		}

		drop(title: title, message: error.localizedDescription)
	}

}
