//
//  AppColors.swift
//  TabsUp
//
//  Created by Thomas Weschke on 09/01/2026.
//

import SwiftUI

struct AppColors {
    // Teal/Green accent color (from mockups)
    static let tealAccent = Color(hex: "00D4AA")
    
    // Purple accent color (from mockups)
    static let purpleAccent = Color(hex: "9B59B6")
    
    // Dark background (dark purple-grey)
    static let darkBackground = Color(hex: "1A1A2E")
    
    // Card background (slightly lighter than dark background)
    static let cardBackground = Color(hex: "2A2A3E")
    
    // Text colors
    static let primaryText = Color.white
    static let secondaryText = Color(hex: "CCCCCC")
    
    // Button colors
    static let buttonBackground = tealAccent
    static let buttonText = Color.white
    
    // Icon colors
    static let greenIcon = Color(hex: "00D4AA")
    static let purpleIcon = Color(hex: "9B59B6")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
