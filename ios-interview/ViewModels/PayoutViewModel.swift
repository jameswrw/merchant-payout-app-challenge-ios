//
//  PayoutViewModel.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import Foundation

@Observable
final class PayoutViewModel {
    var currency: Currency = .GBP
    // Amount stored in the smallest currency unit (e.g. pennies/cents)
    var amount: Int = 0
    var iban: String = ""

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
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: trimmed)), trimmed.isEmpty == false {
            amount = Int(trimmed) ?? 0
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
