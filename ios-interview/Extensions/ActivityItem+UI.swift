//
//  ActivityItem+UI.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import SwiftUI

extension ActivityItem {
    
    func arrowIcon() -> some View {
        let (imageName, colour) = switch type {
        case .payout, .fee:
            ("arrow.up", Color.blue)
        case .deposit, .refund:
            ("arrow.down", Color.green)
        }
        
        let image = Image(systemName: imageName)
            .font(.body)
            .foregroundStyle(colour)
            .frame(width: 42, height: 42)
            .background(colour.opacity(0.14), in: Circle())
            .accessibilityHidden(true)
        
        return image
    }
    
    func amountColor() -> Color {
        switch type {
        case .payout, .fee:
                .primary
        case .deposit, .refund:
                .green
        }
    }
    
    func formattedAmount() -> String {
        abs(amount).formatFromMinorCurrencyUnit(currency: currency)
    }
}
