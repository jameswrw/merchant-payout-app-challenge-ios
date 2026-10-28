//
//  HomeScreenViewModelTests.swift
//  ios-interviewTests
//
//  Created by James Weatherley on 27/10/2026.
//

import Testing
@testable import ios_interview

struct HomeScreenViewModelTests {

    @Test func `test availableBalance without merchant data()`() {
        let sut = HomeScreenViewModel(deviceIdentity: nil)
        #expect(sut.availableBalance() == "Loading")
    }
    
    @Test func `test availableBalance with merchant data()`() {
        let sut = HomeScreenViewModel(deviceIdentity: nil)
        sut.merchantData = .init(
            available_balance: 1234,
            pending_balance: 5678,
            currency: .GBP,
            activity: []
        )
        #expect(sut.availableBalance() == "£12.34")
    }
    
    @Test func `test pendingBalance without merchant data()`() {
        let sut = HomeScreenViewModel(deviceIdentity: nil)
        #expect(sut.availableBalance() == "Loading")
    }
    
    @Test func `test pendingBalance with merchant data()`() {
        let sut = HomeScreenViewModel(deviceIdentity: nil)
        sut.merchantData = .init(
            available_balance: 1234,
            pending_balance: 5678910,
            currency: .GBP,
            activity: []
        )
        #expect(sut.pendingBalance() == "£56,789.10")
    }

}
