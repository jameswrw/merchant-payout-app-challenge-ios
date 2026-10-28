//
//  PayoutErrorView.swift
//  ios-interview
//
//  Created by James Weatherley on 28/10/2026.
//

import SwiftUI

struct PayoutErrorView: View {
    
    let message: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .imageScale(.medium)
                .foregroundStyle(.red)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.red)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.red.opacity(0.12))
        )
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

#Preview {
    PayoutErrorView(message: "There was a problem.")
}
