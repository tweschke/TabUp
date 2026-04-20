//
//  TabsUpApp.swift
//  TabsUp
//
//  Created by Thomas Weschke on 09/01/2026.
//

import SwiftUI

@main
struct TabsUpApp: App {
    @AppStorage(AppAppearance.storageKey) private var appearanceRawValue: String = AppAppearance.system.rawValue

    private var appAppearance: AppAppearance {
        AppAppearance(rawValue: appearanceRawValue) ?? .system
    }

    var body: some Scene {
        WindowGroup {
            DashboardPagerView()
                .preferredColorScheme(appAppearance.preferredColorScheme)
        }
    }
}
