//
//  TabsUp_DEVApp.swift
//  TabsUp-DEV
//
//  Created by Thomas Weschke on 09/01/2026.
//

import SwiftUI

@main
struct TabsUp_DEVApp: App {
    init() {
        // Set dark mode appearance
        if #available(iOS 17.0, *) {
            // Dark mode is handled by SwiftUI
        }
    }
    
    var body: some Scene {
        WindowGroup {
            SplitDashboardView()
                .preferredColorScheme(.dark)
        }
    }
}
