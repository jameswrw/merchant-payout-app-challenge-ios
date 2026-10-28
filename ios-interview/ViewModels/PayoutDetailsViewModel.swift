//
//  PayoutDetailsViewModel.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import Foundation

struct PayoutDetailsViewModel: Codable, Hashable, Equatable {
    
    let amount: Int
    let currency: Currency
    let iban: String
    let device_id: UUID?
    
    func confirmPayment() async throws -> PayoutResponse {
        var request = URLRequest(url: API.baseURL.appendingPathComponent("api/payouts"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(self)
        let (data, response) = try await API.session.data(for: request)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            throw NetworkError.badStatus(http.statusCode, errorResponse.error)
        }
        return try JSONDecoder().decode(PayoutResponse.self, from: data)
    }
}
