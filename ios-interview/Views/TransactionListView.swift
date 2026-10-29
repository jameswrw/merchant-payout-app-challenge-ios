//
//  TransactionListView.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import SwiftUI

struct TransactionListView: View {
    @State private var viewModel = TransactionListViewModel()

    var body: some View {
        Group {
            if viewModel.activityItems.isEmpty {
                ContentUnavailableView(
                    "Transactions",
                    systemImage: "list.bullet.rectangle",
                    description: Text("Your full transaction history will appear here.")
                )
            } else {
                TransactionActivityList(
                    sections: viewModel.activitySections,
                    lastActivityItemID: viewModel.activityItems.last?.id,
                    loadMore: viewModel.update
                )
            }
        }
        .task {
            await viewModel.update()
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TransactionActivityList: View {
    let sections: [TransactionDateSection]
    let lastActivityItemID: String?
    let loadMore: @MainActor () async -> Void

    var body: some View {
        List {
            ForEach(sections) { section in
                Section {
                    ForEach(section.activityItems) { item in
                        ActivityRowView(activityItem: item)
                            .padding(.vertical, 4)
                            .listRowInsets(
                                EdgeInsets(top: 0, leading: 24, bottom: 8, trailing: 24)
                            )
                            .onAppear {
                                guard item.id == lastActivityItemID else {
                                    return
                                }

                                Task {
                                    await loadMore()
                                }
                            }
                    }
                } header: {
                    TransactionDateHeader(viewModel:.init(date: section.date))
                }
            }
        }
        .listStyle(.plain)
    }
}

private struct TransactionDateHeader: View {
    let viewModel: TransactionDateHeaderViewModel
    @Environment(\.calendar) private var calendar

    var body: some View {
        Text(viewModel.formatDate(withCalendar: calendar))
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .accessibilityAddTraits(.isHeader)
            .padding(.top, 20)
    }
}

#Preview {
    NavigationStack {
        TransactionListView()
    }
}
