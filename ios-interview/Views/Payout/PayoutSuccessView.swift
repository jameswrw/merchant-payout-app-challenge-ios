//
//  PayoutSuccessView.swift
//  ios-interview
//
//  Created by James Weatherley on 28/10/2026.
//

import SwiftUI

struct PayoutSuccessView: View {
    
    @Environment(\.navigation) private var navigation
    let viewModel: PayoutResponse
    
    var body: some View {
        ZStack {
            VStack(spacing: 36) {
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 144))
                        .foregroundStyle(.green)
                    Text("Payout Submitted")
                        .font(.title)
                        .fontWeight(.bold)
                    Text(viewModel.amount.formatFromMinorCurrencyUnit(currency: viewModel.currency))
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    Text("to \(viewModel.iban.redacted())")
                }
                VStack(spacing: 4) {
                    Text("Reference")
                        .foregroundStyle(.secondary)
                    Text(viewModel.id)
                        .foregroundStyle(.secondary)
                }
            }
            VStack {
                Spacer()
                ProceedButton("Done") {
                    navigation.path = NavigationPath()
                }
            }
        }
        .navigationTitle("Success")
    }
}

#Preview {
    PayoutSuccessView(
        viewModel: .init(
            id: "payout_1793145994_16ed2c48",
            status: .pending,
            amount: 1234,
            currency: .GBP,
            iban: "GB29NWBK60161331926819",
            created_at: "25 Dec 2025"
        )
    )
}

