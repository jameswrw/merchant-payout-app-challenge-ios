//
//  CurrencyFormattingTests.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import Foundation
import Testing
@testable import ios_interview

@Suite(.serialized)
struct CurrencyFormattingTests {

    let amounts = [-1_000_000, -1_000, -100, 0, 100, 1_000, 1_000_000]
    let expectedSignedResults = [
        "-£10,000.00",
        "-£10.00",
        "-£1.00",
        "£0.00",
        "£1.00",
        "£10.00",
        "£10,000.00"
    ]
    let expectedUnsignedResults = [
        "£10,000.00",
        "£10.00",
        "£1.00",
        "£0.00",
        "£1.00",
        "£10.00",
        "£10,000.00"
    ]

    init() {
        UserDefaults.standard.set("en_GB", forKey: "AppleLocale")
    }

    @Test func `test formatFromMinorCurrencyUnit int extension`() {
        let formattedAmounts = amounts.map { $0.formatFromMinorCurrencyUnit(currency: .GBP) }
        #expect(expectedSignedResults == formattedAmounts)
    }

    @Test func `test ActivityItem formattedAmount()`() {
        let activityItems = amounts.map { amount in
            ActivityItem(
                id: "123",
                type: .payout,
                amount: amount,
                currency: .GBP,
                date: Date().formatted(),
                description: "Payment",
                status: .completed
            )
        }
        let formatted_amounts = activityItems.map { $0.formattedAmount() }
        #expect(formatted_amounts == expectedUnsignedResults)
    }
}
