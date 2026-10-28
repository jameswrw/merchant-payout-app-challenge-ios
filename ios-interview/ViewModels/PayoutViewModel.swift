//
//  PayoutViewModel.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import Foundation

@Observable
final class PayoutViewModel {
    
    var currency: Currency
    var amount: Int
    var iban: String
    var deviceIdentity: UUID?
    
    init(currency: Currency = .GBP, amount: Int = 0, iban: String = "", deviceIdentity: UUID?) {
        self.currency = currency
        self.amount = amount
        self.iban = iban
        self.deviceIdentity = deviceIdentity
    }
    
    // Formatter configured with the current currency. Use per-call creation to respect currency changes.
    private func makeFormatter() -> NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = currency.rawValue
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        f.generatesDecimalNumbers = true
        return f
    }

    var formattedAmount: String {
        amount.formatFromMinorCurrencyUnit(currency: currency)
    }

    // Parse a user-entered currency string and update `amountInMinorUnits`.
    // Accepts plain digits (e.g. "1234") or localized currency text (e.g. "£12.34").
    func updateAmount(from input: String) {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)

        // If the input contains only digits, treat it as minor units.
        if let allDigits = Int(input) {
            amount = allDigits
            return
        }

        // Otherwise, try to parse a localized currency/decimal value and convert to minor units.
        let formatter = makeFormatter()
        if let number = formatter.number(from: trimmed) ?? NumberFormatter.localizedStringToNumber(trimmed) {
            let decimal = NSDecimalNumber(decimal: number.decimalValue)
            let minor = decimal.multiplying(by: 100).rounding(accordingToBehavior: nil)
            amount = minor.intValue
        } else {
            amount = 0
        }
    }
    
    func authenticate() -> Bool {
        // Only need to authenticate for over 1000 major currency units.
        guard amount > 100_000 else {
            return true
        }
        
        return false
    }
}

extension NumberFormatter {
    /// Fallback parser that attempts to read a decimal number using the current locale.
    static func localizedStringToNumber(_ string: String) -> NSNumber? {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.generatesDecimalNumbers = true
        return f.number(from: string)
    }
}
