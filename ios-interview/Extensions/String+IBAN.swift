//
//  String+IBAN.swift
//  ios-interview
//
//  Created by James Weatherley on 28/10/2026.
//

import Foundation

extension String {
    
    /// Redacts by replacing the string with the first four characters followed by three sets of four asterisks followed by the last four characters
    /// the groups of characters are separated by a space
    /// If the string is less than eight characters long it redacts the string by returning four asterisks
    /// - Returns: A redacted string - useful for displaying sensitive data
    func redacted() -> String {
        guard self.count >= 8 else {
            return "****"
        }
        
        let chunks: [String] = [
            String(self.prefix(4)),
            "****",
            "****",
            "****",
            String(self.suffix(4))
        ]

        return chunks.joined(separator: " ")
    }
}
