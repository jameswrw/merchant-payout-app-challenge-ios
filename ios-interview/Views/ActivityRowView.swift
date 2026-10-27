//
//  ActivityRowView.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import SwiftUI

struct ActivityRowView: View {
    
    var activityItem: ActivityItem
    
    var body: some View {
        HStack(spacing: 12) {
            activityItem.arrowIcon()

            VStack(alignment: .leading, spacing: 4) {
                Text(activityItem.description)
                    .font(.system(size: 16))
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(activityItem.status.rawValue.capitalized)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.green)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 3)
                    .background(
                        .green.opacity(0.14),
                        in: Capsule()
                    )
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(activityItem.formattedAmount())
                .font(.body)
                .foregroundStyle(activityItem.amountColor())
        }
    }
}

#Preview {
    ActivityRowView(
        activityItem: ActivityItem(
            id: "1234",
            type: .deposit,
            amount: 1_000,
            currency: .GBP,
            date: Date(timeIntervalSince1970: 0).formatted(),
            description: "Gift",
            status: .completed)
    )
}
