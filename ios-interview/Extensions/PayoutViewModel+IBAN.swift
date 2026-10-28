//
//  PayoutViewModel+IBAN.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import Foundation

extension PayoutViewModel {
    private var normalizedIBAN: String {
        iban.uppercased().replacingOccurrences(of: " ", with: "")
    }

    var isIBANFormatPlausible: Bool {
        let s = normalizedIBAN
        // Basic structure: 2 letters, 2 digits, then 11–30 alphanumeric (total 15–34)
        guard s.count >= 15, s.count <= 34 else { return false }
        guard s.prefix(2).allSatisfy({ $0.isLetter }) else { return false }
        let nextTwo = s.dropFirst(2).prefix(2)
        guard nextTwo.allSatisfy({ $0.isNumber }) else { return false }
        guard s.allSatisfy({ $0.isLetter || $0.isNumber }) else { return false }
        return true
    }

    var isIBANValid: Bool {
        guard isIBANFormatPlausible else { return false }
        return Self.mod97Check(iban: normalizedIBAN)
    }

    private static func mod97Check(iban: String) -> Bool {
        // Move first 4 chars to the end
        let rotated = iban.dropFirst(4) + iban.prefix(4)

        // Expand letters A=10 ... Z=35
        var digits = ""
        digits.reserveCapacity(rotated.count * 2)
        for ch in rotated {
            if let v = ch.wholeNumberValue {
                digits.append(String(v))
            } else if let ascii = ch.asciiValue, ch.isLetter {
                // 'A' → 10 ... 'Z' → 35
                let value = Int(ascii - 55) // 65 ('A') → 10
                digits.append(String(value))
            } else {
                return false
            }
        }

        // Compute remainder incrementally to avoid big integers
        var remainder = 0
        for ch in digits {
            guard let v = ch.wholeNumberValue else { return false }
            remainder = (remainder * 10 + v) % 97
        }
        return remainder == 1
    }
}
