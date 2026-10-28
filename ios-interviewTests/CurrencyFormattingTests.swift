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

    @Test(
        arguments:
            [
                (-1_000_000, "-£10,000.00"),
                (-1_000, "-£10.00"),
                (-100, "-£1.00"),
                (0, "£0.00"),
                (100, "£1.00"),
                (1_000, "£10.00"),
                (1_000_000, "£10,000.00"),
            ]
    )
    func `test formatFromMinorCurrencyUnit int extension`(amount: Int, formatted: String) {
        #expect(amount.formatFromMinorCurrencyUnit(currency: .GBP) == formatted)
    }

    @Test(
        arguments:
            [
                (-1_000_000, "£10,000.00"),
                (-1_000, "£10.00"),
                (-100, "£1.00"),
                (0, "£0.00"),
                (100, "£1.00"),
                (1_000, "£10.00"),
                (1_000_000, "£10,000.00"),
            ]
    )
    func `test ActivityItem formattedAmount()`(amount: Int, formatted: String) {
        let sut = ActivityItem(
            id: "1234",
            type: .deposit,
            amount: amount,
            currency: .GBP,
            date: Date().formatted(),
            description: "Testing",
            status: .completed
        )
        #expect(sut.formattedAmount() == formatted)
    }
}
