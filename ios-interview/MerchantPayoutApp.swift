//
//  MerchantPayoutApp.swift
//  ios-interview
//
//  Created by Checkout.com on 21/05/2026.
//

import SwiftUI

@main
struct MerchantPayoutApp: App {
    
    var deviceIdentity: UUID?
    
    var body: some Scene {
        WindowGroup {
            HomeScreenView(viewModel: .init(deviceIdentity: deviceIdentity))
        }
    }
    
    init() {
        // Register MockURLProtocol so URLSession.shared also routes through the mock server.
        URLProtocol.registerClass(MockURLProtocol.self)
        let keychainPersistance = DeviceIdentifierPersistance()
        
        deviceIdentity = keychainPersistance.fetchUUID()
        if deviceIdentity == nil {
            deviceIdentity = UUID()
            if let deviceIdentity {
                keychainPersistance.save(uuid: deviceIdentity)
            }
        }
    }
}

