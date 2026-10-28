//
//  PayoutViewModelTests.swift
//  ios-interviewTests
//
//  Created by James Weatherley on 28/10/2026.
//

import Testing
@testable import ios_interview

struct PayoutViewModelTests {

    @Test(
        arguments: [
            ("GB29NWBK60161331926819", true),
            ("GB29 NWBK 6016 1331 9268 19", true),
            ("gb29NWBK60161331926819", true),
            ("GB29NWBK60161331926818", true),
            ("GB29 NWBK 6016 1331 9268 18", true),
            ("gb29NWBK60161331926818", true),
            ("??29NWBK60161331926818", false),
            ("gb29", false),
        ]
    )
    func `test if iban is plausible`(iban: String, valid: Bool) {
        let sut = PayoutViewModel(currency: .GBP, amount: 1234, iban: iban, deviceIdentity: nil)
        #expect(sut.isIBANFormatPlausible == valid)
    }
    
    @Test(
        arguments: [
            ("GB29NWBK60161331926819", true),
            ("GB29 NWBK 6016 1331 9268 19", true),
            ("gb29NWBK60161331926819", true),
            ("GB29NWBK60161331926818", false),
            ("GB29 NWBK 6016 1331 9268 18", false),
            ("gb29NWBK60161331926818", false),
            ("??29NWBK60161331926818", false),
            ("gb29", false),
        ]
    )
    func `test if iban is valid`(iban: String, valid: Bool) {
        let sut = PayoutViewModel(currency: .GBP, amount: 1234, iban: iban, deviceIdentity: nil)
        #expect(sut.isIBANValid == valid)
    }
    
    @Test(
        arguments: [
            ("1234", 1234),
            ("12.34", 1234),
            ("£1,234.00", 123400),
            ("one two three", 0),
            ("", 0),
            ("-3456", -3456),
            ("-£33.33", -3333),
        ]
    )
    func `test updateAmount()`(input: String, amount: Int) {
        let sut = PayoutViewModel(currency: .GBP, amount: 0, iban: "GB29NWBK60161331926819", deviceIdentity: nil)
        sut.updateAmount(from: input)
        #expect(sut.amount == amount)
    }

}
