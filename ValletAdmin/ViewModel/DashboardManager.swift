//
//  DashboardManager.swift
//  Vallet
//
//  Created by Matija Kregar on 08/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

class DashboardManager {

	static func incomingSum(for events: [ValueEvent]) -> Int64 {
		return events.filter({$0.type == .redeem}).compactMap({$0.value}).reduce(0, +)
	}

	static func outgoingSum(for events: [ValueEvent]) -> Int64 {
		return events.filter({$0.type == .issue}).compactMap({$0.value}).reduce(0, +)
	}

	static func monthsData(for events: [ValueEvent], preceedingCount: Int) -> [DashboardMonth] {
		var dashboardMonths = [DashboardMonth]()

		let calendar = Calendar.current
		let grouped = Dictionary(grouping: events, by: { (event) -> Date in
			guard let date = event.date
				else {
					return calendar.startOfMonth(for: Date.distantPast)
			}
			return calendar.startOfMonth(for: date)
		})

		let startDates = preceedingMonthsStartDates(for: preceedingCount)

		var maxSum: Int64 = 1
		for startDate in startDates {
			let month = calendar.component(.month, from: startDate)
			let dashboardMonth = DashboardMonth(month: month)
			if let monthEvents = grouped[startDate] {
				dashboardMonth.incoming = incomingSum(for: monthEvents)
				dashboardMonth.outgoing = outgoingSum(for: monthEvents)
				let monthMax = max(dashboardMonth.incoming, dashboardMonth.outgoing)
				if monthMax > maxSum {
					maxSum = monthMax
				}
			}
			dashboardMonths.append(dashboardMonth)
		}

		for dashboardMonth in dashboardMonths {
			dashboardMonth.fullScale = maxSum
		}

		return dashboardMonths
	}

	private static func preceedingMonthsStartDates(for numMonths: Int) -> [Date] {
		var dates = [Date]()

		let calendar = Calendar.current
		let date = Date()

		let currentMonth = calendar.component(.month, from: date)
		let currentYear = calendar.component(.year, from: date)

		var month = currentMonth
		var year = currentYear

		while dates.count < numMonths {
			if month == 0 {
				month = 12
				year -= 1
			}
			if let date = calendar.startOfMonth(for: month, year: year) {
				dates.append(date)
			}
			month -= 1
		}

		return dates.reversed()
	}

}

class DashboardMonth: CustomStringConvertible {

	var month: Int = 0

	var incoming: Int64 = 0
	var outgoing: Int64 = 0

	var fullScale: Int64 = 1

	let dateFormatter = DateFormatter()

	init(month: Int) {
		self.month = month
	}

	var monthName: String {
		guard let allMonthNames = dateFormatter.shortMonthSymbols,
			month > 0,
			month <= allMonthNames.count
			else {
				return ""
		}
		return allMonthNames[month - 1]
	}

	var normalisedIncoming: Double {
		return Double(incoming)/Double(fullScale)
	}

	var normalisedOutgoing: Double {
		return Double(outgoing)/Double(fullScale)
	}

	var description: String {
		return "month: \(month), incoming: \(incoming), outgoing: \(outgoing), fullScale: \(fullScale)"
	}

}
