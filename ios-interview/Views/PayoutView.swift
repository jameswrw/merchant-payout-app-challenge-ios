//
//  PayoutView.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import SwiftUI

struct PayoutView: View {
    var body: some View {
        ContentUnavailableView(
            "Payout",
            systemImage: "list.bullet.rectangle",
            description: Text("Payout UI will appear here.")
        )
        .navigationTitle("Payout")
    }
}

#Preview {
    PayoutView()
}
