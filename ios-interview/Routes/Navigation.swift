//
//  Navigation.swift
//  ios-interview
//
//  Created by James Weatherley on 28/10/2026.
//

import SwiftUI

@Observable
final class Navigation {
    var path = NavigationPath()
}

extension EnvironmentValues {
    private struct NavigationKey: EnvironmentKey {
        static let defaultValue = Navigation()
    }

    var navigation: Navigation {
        get { self[NavigationKey.self] }
        set { self[NavigationKey.self] = newValue }
    }
}
