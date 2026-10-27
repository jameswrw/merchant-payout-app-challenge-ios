//
//  TransactionListView.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import SwiftUI

struct TransactionListView: View {
    var body: some View {
        ContentUnavailableView(
            "Transactions",
            systemImage: "list.bullet.rectangle",
            description: Text("Your full transaction history will appear here.")
        )
        .navigationTitle("Transactions")
    }
}

#Preview {
    TransactionListView()
}
