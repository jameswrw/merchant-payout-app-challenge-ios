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
    let viewModel: PayoutDetailsViewModel
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
            VStack {
                PayoutDetailsView(viewModel: viewModel)
                    .padding()
                Spacer()
                Button {
                    Task {
                        do {
                            payoutResponse = try await viewModel.confirmPayment()
                            if let payoutResponse {
                                navigation.path.append(Route.payoutSuccess(payoutResponse))
                            }
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Confirm Payout",
                         comment: "Primary action button that confirms a merchant payout.")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
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
            iban: "GB29NWBK60161331926819"
        )
    )
}
