//
//  ConfirmPayoutView.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import SwiftUI

struct ConfirmPayoutView: View {

    @Environment(\.navigation) private var navigation
    @State var payoutResponse: PayoutResponse?
    @State private var errorMessage: String?
    let viewModel: PayoutDetailsViewModel
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
            VStack {
                PayoutDetailsView(viewModel: viewModel)
                    .padding()
                if let errorMessage {
                    PayoutErrorView(message: errorMessage)
                }
                Spacer()
                ProceedButton(
                    "Confirm Payout",
                    accessibilityIdentifier: "confirmPayout",
                    accessibilityHint: "Confirm the payout"
                ) {
                    Task {
                        let result = await viewModel.confirmPaymentHandlingError()
                        switch result {
                        case .success(let response):
                            payoutResponse = response
                            errorMessage = nil
                            navigation.path.append(Route.payoutSuccess(response))
                        case .failure(let message):
                            switch message {
                            case .payoutError(let message):
                                errorMessage = message
                            }
                        }
                    }
                }
                .navigationTitle("Confirm Payout")
            }
        }
    }
}

#Preview {
    ConfirmPayoutView(
        viewModel: .init(
            amount: 1234,
            currency: .GBP,
            iban: "GB29NWBK60161331926819",
            device_id: nil
        )
    )
}

