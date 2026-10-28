//
//  HomeScreenView.swift
//  ios-interview
//
//  Created by Checkout.com on 21/05/2026.
//

import SwiftUI

struct HomeScreenView: View {
    @State var viewModel: HomeScreenViewModel
    @State private var navigation = Navigation()
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            ZStack {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                VStack(alignment: .leading, spacing: 16) {
                    Text("Merchant Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if viewModel.merchantData != nil {
                        BalanceView(viewModel: viewModel)

                        RecentActivityView(viewModel: viewModel)
                        
                        Spacer()

                        Button {
                            navigation.path.append(Route.payout)
                        } label: {
                            Text("Send Payout",
                                 comment: "Primary action button that starts a merchant payout.")
                        }
                        .accessibilityIdentifier("sendPayout")
                        .buttonStyle(.borderedProminent)
                        .controlSize(.regular)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        ContentUnavailableView(
                            "Merchant Dashboard",
                            systemImage: "list.bullet.rectangle",
                            description: Text("Home screen is loading")
                        )
                    }
                }
                .padding()
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .payout:
                    PayoutView(viewModel: PayoutViewModel(deviceIdentity: viewModel.deviceIdentity))
                case .payoutConfirm(let payoutDetailsViewModel):
                    ConfirmPayoutView(viewModel: payoutDetailsViewModel)
                case .payoutSuccess(let payoutResponse):
                    PayoutSuccessView(viewModel: payoutResponse)
                case .transactionList:
                    TransactionListView()
                }
            }
        }
        .task {
            await viewModel.update()
        }
        .environment(\.navigation, navigation)
    }
}

#Preview {
    HomeScreenView(viewModel: .init(deviceIdentity: nil))
}
