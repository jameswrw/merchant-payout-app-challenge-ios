//
//  RecentActivityView.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import SwiftUI

struct RecentActivityView: View {
    @Bindable var viewModel: HomeScreenViewModel

    var body: some View {
        VStack(spacing: 0) {
            RecentActivityHeader()

            if let activity = viewModel.merchantData?.activity {
                RecentActivityList(activity: activity)
            }
        }
        .background(.background, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct RecentActivityHeader: View {
    var body: some View {
        HStack {
            Text("Recent Activity")
                .font(.title3)
                .fontWeight(.semibold)
                .accessibilityAddTraits(.isHeader)

            Spacer()

            NavigationLink {
                TransactionListView()
            } label: {
                Text("View All")
                    .font(.body)
                    .fontWeight(.semibold)
            }
        }
        .padding()
    }
}

private struct RecentActivityList: View {
    let activity: [ActivityItem]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(activity) { item in
                ActivityRowView(activityItem: item)
                    .padding()

                if item.id != activity.last?.id {
                    Divider()
                        .padding(.leading, 96)
                }
            }
        }
    }
}

#Preview {
    let viewModel = HomeScreenViewModel()
    RecentActivityView(viewModel: viewModel)
        .task {
            await viewModel.update()
        }
}
