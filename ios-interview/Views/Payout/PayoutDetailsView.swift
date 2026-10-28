//
//  ConfirmPayoutView.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import SwiftUI

struct PayoutDetailsView: View {
    
    let viewModel: PayoutDetailsViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ConfirmPayoutRowView(leadingText: "Amount", trailingText: viewModel.amount.formatFromMinorCurrencyUnit(currency: viewModel.currency))
            Divider()
                .padding()
            ConfirmPayoutRowView(leadingText: "Currency", trailingText: viewModel.currency.rawValue)
            Divider()
                .padding()
            ConfirmPayoutRowView(leadingText: "IBAN", trailingText: viewModel.iban.redacted())
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    PayoutDetailsView(
        viewModel: .init(
            amount: 1234,
            currency: .GBP,
            iban: "GB29NWBK60161331926819",
            device_id: nil
        )
    )
}
