//
//  BalanceView.swift
//  ios-interview
//

import SwiftUI

struct BalanceView: View {
    @Bindable var viewModel: HomeScreenViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Available Balance")
                .font(.title3)
                .foregroundStyle(.secondary)

            Text(viewModel.availableBalance())
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 16)
                .padding(.bottom, 18)

            Divider()
                .overlay(Color.secondary.opacity(0.18))

            HStack(spacing: 12) {
                Image(systemName: "clock")
                    .font(.title3)

                Text("Pending")

                Spacer()

                Text(viewModel.pendingBalance())
            }
            .font(.title3)
            .foregroundStyle(.secondary)
            .padding(.top, 16)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .systemBackground),
                    in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    let viewModel = HomeScreenViewModel(deviceIdentity: nil)
    BalanceView(viewModel: viewModel)
        .task {
            await viewModel.update()
        }
        .padding()
        .background(Color(uiColor: .systemGroupedBackground))
}
