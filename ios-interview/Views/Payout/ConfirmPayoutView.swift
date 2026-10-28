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
                ProceedButton("Confirm Payout") {
                    Task {
                        do {
                            payoutResponse = try await viewModel.confirmPayment()
                            errorMessage = nil
                            if let payoutResponse {
                                navigation.path.append(Route.payoutSuccess(payoutResponse))
                            }
                        } catch NetworkError.badStatus(let statusCode, let reason) {
                            switch statusCode {
                            case 400:
                                errorMessage = "\(reason). Please check your available balance."
                            case 503:
                                errorMessage = "\(reason). Please try again later."
                            default:
                                errorMessage = "There was a problem. Please try again later."
                            }
                        } catch {
                            errorMessage = "There was a problem. Please try again later."
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
