//
//  TransactionListViewModelTests.swift
//  ios-interviewTests
//
//  Created by James Weatherley on 29/10/2026.
//

import Testing
@testable import ios_interview

struct TransactionListViewModelTests {

    @MainActor
    @Test func `test pagination`() async throws {
        let sut = TransactionListViewModel()
        #expect(sut.activityItems.count == 0)
        #expect(sut.nextCursor == nil)
        
        await sut.update()
        #expect(sut.activityItems.count == 15)
        #expect(sut.nextCursor != nil)
        #expect(sut.hasMore == true)
        
        await sut.update()
        #expect(sut.activityItems.count == 30)
        #expect(sut.nextCursor == nil)
        #expect(sut.hasMore == false)
    }

}
