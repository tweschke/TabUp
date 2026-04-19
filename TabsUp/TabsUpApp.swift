//
//  TabsUpApp.swift
//  TabsUp
//
//  Created by Thomas Weschke on 09/01/2026.
//

import SwiftUI

@main
struct TabsUpApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardPagerView()
                .preferredColorScheme(.dark)
        }
    }
}
