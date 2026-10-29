//
//  PayoutDetailsViewModel.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import Foundation

enum PayoutError: Error{
    case payoutError(String)
}

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
    
    /// Confirms the payment and maps any errors to a user-facing message.
    /// - Returns: A Result that contains either the successful `PayoutResponse` or a localized error message.
    func confirmPaymentHandlingError() async -> Result<PayoutResponse, PayoutError> {
        do {
            let response = try await confirmPayment()
            return .success(response)
        } catch NetworkError.badStatus(let statusCode, let reason) {
            switch statusCode {
            case 400:
                return .failure(.payoutError("\(reason). Please check your available balance."))
            case 503:
                return .failure(.payoutError("\(reason). Please try again later."))
            default:
                return .failure(.payoutError("There was a problem. Please try again later."))
            }
        } catch {
            return .failure(.payoutError("There was a problem. Please try again later."))
        }
    }
}
