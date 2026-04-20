//
//  DesignTypography.swift
//  TabsUp
//
//  Point-size typography used alongside dynamic styles (`.headline`, etc.).
//

import SwiftUI

enum DesignTypography {
    /// Dashboard “Split” / “Tip” screen titles.
    static let dashboardScreenTitle = Font.system(size: 36, weight: .bold)

    /// Total Bill primary amount (hero row).
    static let totalBillHero = Font.system(size: 34, weight: .bold)

    /// Large monetary amounts (per person, weighted range, tip totals).
    static let largeMetric = Font.system(size: 32, weight: .bold)

    /// Tip tab summary emphasis line.
    static let tipSummaryPrimary = Font.system(size: 28, weight: .bold)

    /// Keypad and large numeric entry (amount / tip).
    static let keypadDisplay = Font.system(size: 48, weight: .light)

    /// Breakdown weight / avatar glyph on purple circle.
    static let weightStepperGlyph = Font.system(size: 20, weight: .regular)

    /// Fallback layered people icon (rear silhouette).
    static let evenSplitIconRear = Font.system(size: 11, weight: .medium)

    /// Fallback layered people icon (front silhouette).
    static let evenSplitIconFront = Font.system(size: 12, weight: .semibold)

    // MARK: - Semantic system fonts (Dynamic Type)

    /// Sheet / modal top bar: close, centered title, invisible balance button — use with `Image` or `Text`.
    static var sheetNavigationBar: Font { .title2 }

    /// Keypad digit and subtitle stack (same text style scale as sheet bar).
    static var keypadKeyTitle: Font { .title2 }

    /// Trailing settings / overflow on dashboard header (`line.3.horizontal`, etc.).
    static var dashboardBarButton: Font { .title2.weight(.semibold) }

    /// Inline card icons (e.g. people tile SF Symbol, breakdown amount emphasis).
    static var cardInlineIcon: Font { .title3 }
}
