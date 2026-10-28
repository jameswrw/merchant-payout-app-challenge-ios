//
//  ConfirmPayoutRowView.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import SwiftUI

struct ConfirmPayoutRowView: View {
    
    let leadingText: String
    let trailingText: String
    
    var body: some View {
        HStack {
            Text(leadingText)
                .foregroundStyle(.secondary)
            Spacer()
            Text(trailingText)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    ConfirmPayoutRowView(leadingText: "Amount", trailingText: "£12.34")
}
