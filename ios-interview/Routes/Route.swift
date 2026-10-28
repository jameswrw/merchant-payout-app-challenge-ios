//
//  Route.swift
//  ios-interview
//
//  Created by James Weatherley on 28/10/2026.
//

enum Route: Hashable {
    case payout
    case payoutConfirm(PayoutDetailsViewModel)
    case payoutSuccess(PayoutResponse)
    case transactionList
}
