//
//  Int+CurrencyFormatting.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import Foundation

extension Int {
    
    /// Given an amount in minor currency units (e.g. pence) return a formatted string in major and minor units.
    ///  For example 1234 GBP would return "£12.34"
    /// - Returns: Currency string formatted for the locale.
    ///
    func formatFromMinorCurrencyUnit(currency: Currency) -> String {
        let majorCurrencyUnit = Decimal(self) / 100.0
        return majorCurrencyUnit.formatted(.currency(code: currency.rawValue))
    }
}
