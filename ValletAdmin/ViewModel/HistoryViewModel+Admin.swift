//
//  HistoryViewModel+Admin.swift
//  ValletAdmin
//
//  Created by Matija Kregar on 08/10/2018.
//  Copyright © 2018 Matija Kregar. All rights reserved.
//

import Foundation

extension HistoryViewModel {

	var incomingSum: Int64 {
		return DashboardManager.incomingSum(for: events)
	}

	var outgoingSum: Int64 {
		return DashboardManager.outgoingSum(for: events)
	}

	func dashboardMonths(preceedingCount: Int) -> [DashboardMonth] {
		return DashboardManager.monthsData(for: events, preceedingCount: preceedingCount)
	}

}
