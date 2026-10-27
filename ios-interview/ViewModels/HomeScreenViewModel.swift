//
//  HomeScreenViewModel.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import Foundation

@Observable
class HomeScreenViewModel {
    var merchantData: MerchantData?
    
    func update() async {
        let url = API.baseURL.appendingPathComponent("api/merchant")
        do {
            let (data, response) = try await API.session.data(from: url)
            let merchant = try JSONDecoder().decode(MerchantData.self, from: data)
            self.merchantData = merchant
        } catch {
            print(error)
        }
    }
    
    func availableBalance() -> String {
        if let merchantData {
            return merchantData.available_balance.formatFromMinorCurrencyUnit(currency: merchantData.currency)
        }
        return "Loading"
    }
    
    func pendingBalance() -> String {
        if let merchantData {
            return merchantData.pending_balance.formatFromMinorCurrencyUnit(currency: merchantData.currency)
        }
        return "Loading"
    }
}

