//
//  AppColors.swift
//  TabsUp
//
//  Created by Thomas Weschke on 09/01/2026.
//

import SwiftUI
import UIKit

struct AppColors {
    // Teal/Green accent color (from mockups)
    static let tealAccent = Color(hex: "00D4AA")

    // Purple accent color (from mockups)
    static let purpleAccent = Color(hex: "9B59B6")

    // Icon colors
    static let greenIcon = Color(hex: "00D4AA")
    static let purpleIcon = Color(hex: "9B59B6")

    // MARK: - Semantic surfaces & text (light / dark aware)

    /// Main screen background.
    static let primaryBackground = adaptiveColor(
        light: UIColor(red: 247 / 255, green: 248 / 255, blue: 252 / 255, alpha: 1), // #F7F8FC
        dark: UIColor(red: 26 / 255, green: 26 / 255, blue: 46 / 255, alpha: 1)
    )

    /// Legacy name; resolves to the same dynamic color as `primaryBackground`.
    static var darkBackground: Color { primaryBackground }

    /// Card and grouped control surfaces.
    static let cardBackground = adaptiveColor(
        light: .white,
        dark: UIColor(red: 42 / 255, green: 42 / 255, blue: 62 / 255, alpha: 1)
    )

    /// Primary label / body text.
    static let primaryText = adaptiveColor(
        light: .label,
        dark: .white
    )

    /// Secondary / supporting text.
    static let secondaryText = adaptiveColor(
        light: .secondaryLabel,
        dark: UIColor(red: 204 / 255, green: 204 / 255, blue: 204 / 255, alpha: 1)
    )

    /// Hairline borders on cards and controls.
    static let borderSubtle = adaptiveColor(
        light: UIColor.separator,
        dark: UIColor.white.withAlphaComponent(0.1)
    )

    /// Inactive tip chips and similar controls — slightly lighter than before in light mode for Phase 3.
    static let chipInactiveBackground = adaptiveColor(
        light: UIColor.quaternarySystemFill,
        dark: UIColor(red: 42 / 255, green: 42 / 255, blue: 62 / 255, alpha: 1)
    )

    /// Inactive split-type buttons only: softer neutral than tip chips (quaternary in light).
    static let splitTypeInactiveBackground = adaptiveColor(
        light: UIColor.quaternarySystemFill,
        dark: UIColor(red: 42 / 255, green: 42 / 255, blue: 62 / 255, alpha: 1)
    )

    /// ± steppers on the Split dashboard: lighter neutral fill in light; dark keeps purple tint (see usage).
    static var stepperControlLightFill: Color { Color(UIColor.tertiarySystemFill) }

    /// Light mode: soft purple-tinted stepper surfaces (mockup parity).
    static let stepperPurpleTintLight = Color(hex: "EDE7F5")

    /// Icon tint on ± buttons (purple accent, readable on `stepperPurpleTintLight`).
    static let stepperIconTint = purpleAccent

    // MARK: - Brand gradient (light: mint → sky blue → violet-blue; dark: teal → purple)

    /// Light-mode primary CTA: brighter mint start, cleaner cyan center, deeper violet-blue end.
    static let brandGradientLightMintTeal = Color(hex: "43DFC0")
    static let brandGradientLightSkyBlue = Color(hex: "4FB3FF")
    static let brandGradientLightVioletBlue = Color(hex: "5D5AF6")

    /// Shared brand gradient for primary CTA and other full-strength brand accents. Matches dashboard CTA direction per color scheme.
    static func gradient(colorScheme: ColorScheme) -> LinearGradient {
        switch colorScheme {
        case .light:
            return LinearGradient(
                stops: [
                    .init(color: brandGradientLightMintTeal, location: 0.00),
                    .init(color: brandGradientLightSkyBlue, location: 0.56),
                    .init(color: brandGradientLightVioletBlue, location: 1.00)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .dark:
            return LinearGradient(
                colors: [tealAccent.opacity(0.95), purpleAccent.opacity(0.78)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        @unknown default:
            return LinearGradient(
                colors: [
                    brandGradientLightMintTeal,
                    brandGradientLightSkyBlue,
                    brandGradientLightVioletBlue
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }

    /// Soft circular / small-surface tint derived from brand colors (result anchors, etc.).
    static func brandTintGradient(colorScheme: ColorScheme) -> LinearGradient {
        switch colorScheme {
        case .light:
            return LinearGradient(
                colors: [
                    tealAccent.opacity(0.46),
                    purpleAccent.opacity(0.36)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .dark:
            return LinearGradient(
                colors: [
                    tealAccent.opacity(0.52),
                    purpleAccent.opacity(0.42)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        @unknown default:
            return LinearGradient(
                colors: [tealAccent.opacity(0.46), purpleAccent.opacity(0.36)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    /// Selected tip chips: subtle teal–purple tint (reads as a soft fill, not a full CTA).
    static func chipSelectedBackground(colorScheme: ColorScheme) -> LinearGradient {
        switch colorScheme {
        case .light:
            return LinearGradient(
                colors: [
                    tealAccent.opacity(0.22),
                    purpleAccent.opacity(0.13)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .dark:
            return LinearGradient(
                colors: [
                    tealAccent.opacity(0.30),
                    purpleAccent.opacity(0.19)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        @unknown default:
            return LinearGradient(
                colors: [tealAccent.opacity(0.22), purpleAccent.opacity(0.13)],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }

    /// Selected split-type controls: soft mint-tinted surface (subtle, not a strong brand gradient).
    static func splitTypeSelectedBackground(colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            // Slightly richer mint vs. screen bg so the pill reads more clearly (still soft, no gradient).
            return Color(red: 0.865, green: 0.965, blue: 0.933)
        case .dark:
            return Color(red: 38 / 255, green: 52 / 255, blue: 50 / 255)
        @unknown default:
            return Color(red: 0.865, green: 0.965, blue: 0.933)
        }
    }

    /// Split Type — selected: horizontal teal → purple wash (aligned with tip chip / brand, softer than CTA).
    static func splitTypeSelectedGradient(colorScheme: ColorScheme) -> LinearGradient {
        chipSelectedBackground(colorScheme: colorScheme)
    }

    /// Split Type pills (mockup): very soft white-cyan → mint, left to right — not the tip-chip purple wash.
    static func splitTypePillSelectedGradient(colorScheme: ColorScheme) -> LinearGradient {
        switch colorScheme {
        case .light:
            return LinearGradient(
                colors: [
                    Color(red: 0.97, green: 0.995, blue: 0.995),
                    Color(red: 0.90, green: 0.97, blue: 0.95)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .dark:
            return LinearGradient(
                colors: [
                    Color(red: 32 / 255, green: 48 / 255, blue: 52 / 255),
                    Color(red: 28 / 255, green: 44 / 255, blue: 48 / 255)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        @unknown default:
            return LinearGradient(
                colors: [
                    Color(red: 0.97, green: 0.995, blue: 0.995),
                    Color(red: 0.90, green: 0.97, blue: 0.95)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }

    /// Split Type selected pill border (mockup teal).
    static let splitTypePillBorderTeal = Color(hex: "26C4A6")

    /// Even-split dual-tone icon: rear figure (navy).
    static let splitTypeEvenIconRear = Color(hex: "2C3E50")

    /// Split Type — unselected: flat neutral (paired with hairline border in views).
    static func splitTypeUnselectedFill(colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color.white
        case .dark:
            return Color(red: 42 / 255, green: 42 / 255, blue: 62 / 255)
        @unknown default:
            return Color(red: 247 / 255, green: 247 / 255, blue: 249 / 255)
        }
    }

    /// Add Tip — selected: turquoise/mint (leading) → very pale white-cyan (trailing); squircle chips (mockup).
    static func tipChipSelectedGradient(colorScheme: ColorScheme) -> LinearGradient {
        switch colorScheme {
        case .light:
            return LinearGradient(
                colors: [
                    Color(red: 0.78, green: 0.94, blue: 0.90),
                    Color(red: 0.97, green: 0.995, blue: 0.999)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .dark:
            return LinearGradient(
                colors: [
                    Color(red: 34 / 255, green: 50 / 255, blue: 48 / 255),
                    Color(red: 26 / 255, green: 38 / 255, blue: 42 / 255)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        @unknown default:
            return LinearGradient(
                colors: [
                    Color(red: 0.78, green: 0.94, blue: 0.90),
                    Color(red: 0.97, green: 0.995, blue: 0.999)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }

    /// Add Tip — inactive: same fill as Split Type unselected (“% Weighted” inactive) — single source of truth.
    static func tipChipInactiveFill(colorScheme: ColorScheme) -> Color {
        splitTypeUnselectedFill(colorScheme: colorScheme)
    }

    /// Split Type selected pill: visible teal border (reads on gradient fill).
    static var splitTypeSelectedBorderColor: Color { tealAccent.opacity(0.45) }

    /// Split Type — inactive outline.
    static var splitTypeInactiveBorderColor: Color {
        adaptiveColor(
            light: UIColor.separator.withAlphaComponent(0.65),
            dark: UIColor.white.withAlphaComponent(0.12)
        )
    }

    // Button colors
    static let buttonBackground = tealAccent
    static let buttonText = Color.white

    /// Unselected pager segment — label tint (light) vs muted secondary (dark).
    static func pagerDotUnselected(for colorScheme: ColorScheme) -> Color {
        colorScheme == .light
            ? Color(UIColor.label.withAlphaComponent(0.2))
            : secondaryText.opacity(0.38)
    }

    private static func adaptiveColor(light: UIColor, dark: UIColor) -> Color {
        Color(
            UIColor { traits in
                traits.userInterfaceStyle == .dark ? dark : light
            }
        )
    }
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
