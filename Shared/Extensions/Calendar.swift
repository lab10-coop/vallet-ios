//
//  Calendar.swift
//  Vallet
//
//  Created by Matija Kregar on 08/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

extension Calendar {

	func startOfMonth(for date: Date) -> Date {
		let date = self.date(from: dateComponents([.year,.month], from: date))!
		return startOfDay(for: date)
	}

	func startOfMonth(for month: Int, year: Int) -> Date? {
		let components = DateComponents(calendar: self, year: year, month: month)
		return self.date(from: components)
	}

}
