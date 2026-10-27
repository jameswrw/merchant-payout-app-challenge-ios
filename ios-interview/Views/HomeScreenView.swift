//
//  HomeScreenView.swift
//  ios-interview
//
//  Created by Checkout.com on 21/05/2026.
//

import SwiftUI

struct HomeScreenView: View {
    @State var viewModel = HomeScreenViewModel()
    @State var makePayout = false
    
    var body: some View {
        NavigationStack {
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
                            makePayout = true
                        } label: {
                            Text("Send Payout",
                                 comment: "Primary action button that starts a merchant payout.")
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.regular)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        ContentUnavailableView(
                            "Merchant Dashboard",
                            systemImage: "list.bullet.rectangle",
                            description: Text("Home screen is loading ")
                        )
                    }
                }
                .padding()
            }
            .navigationDestination(isPresented: $makePayout) {
                PayoutView()
            }
        }
        .task {
            await viewModel.update()
        }
    }
}

#Preview {
    HomeScreenView()
}
