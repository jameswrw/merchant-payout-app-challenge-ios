//
//  TransactionDateHeaderViewModel.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import Foundation

struct TransactionDateHeaderViewModel {

    let date: Date
    
    func formatDate(withCalendar calendar: Calendar) -> String {
        if calendar.isDateInToday(date) {
            return String(localized: "Today")
        }
        if calendar.isDateInYesterday(date) {
            return String(localized: "Yesterday")
        }
        if calendar.isDateInTomorrow(date) {
            return String(localized: "Tomorrow")
        }

        return date.formatted(.dateTime.day(.twoDigits).month(.abbreviated).year())
    }
}
