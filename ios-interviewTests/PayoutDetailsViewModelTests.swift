//
//  Test.swift
//  ios-interviewTests
//
//  Created by James Weatherley on 29/10/2026.
//

import Testing
@testable import ios_interview

struct Test {

    @Test func `test successful confirmPayment()`() async throws {
        
        let sut = PayoutDetailsViewModel(amount: 12345, currency: .GBP, iban: "GB29NWBK60161331926819", device_id: nil)
        let result = await sut.confirmPaymentHandlingError()
        switch result {
        case .success(_):
            #expect(true)
        case .failure(_):
            #expect(Bool(false))
        }
    }
    
    @Test func `test insufficient funds confirmPayment()`() async throws {
        let sut = PayoutDetailsViewModel(amount: 88888, currency: .GBP, iban: "GB29NWBK60161331926819", device_id: nil)
        let result = await sut.confirmPaymentHandlingError()
        switch result {
        case .success(_):
            #expect(Bool(false))
        case .failure(let error):
            #expect(true)
            switch error {
            case .payoutError(let message):
                #expect(message == "Insufficient funds. Please check your available balance.")
            }
        }
    }

    @Test func `test service unavailable confirmPayment()`() async throws {
        let sut = PayoutDetailsViewModel(amount: 99999, currency: .GBP, iban: "GB29NWBK60161331926819", device_id: nil)
        let result = await sut.confirmPaymentHandlingError()
        switch result {
        case .success(_):
            #expect(Bool(false))
        case .failure(let error):
            #expect(true)
            switch error {
            case .payoutError(let message):
                #expect(message == "Service temporarily unavailable. Please try again later.")
            }
        }
    }
}
