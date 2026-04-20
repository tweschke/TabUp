//
//  DesignRadius.swift
//  TabsUp
//
//  Single source of truth for corner radii (continuous curves). Aligns with design mockups:
//  large cards ~24–32pt, compact chips ~10–14pt, split type ~16–18pt, dashboard CTA rounded-rect.
//

import CoreGraphics

enum DesignRadius {
    // MARK: - Cards & grouped surfaces (~24–32pt mockup)

    /// Main white cards: Total Bill, Number of People, Per person, Tip totals, breakdown, sheet panels.
    static let card: CGFloat = 28

    // MARK: - Compact controls (~10–14pt mockup)

    /// Add Tip squircles (horizontal chip row) — also used for the **currency code** pill on Total Bill (same active styling).
    static let tipChip: CGFloat = 12

    /// ± steppers beside people count.
    static let stepper: CGFloat = 12

    /// Purple “people” icon tile on Number of People card.
    static let iconTile: CGFloat = 10

    /// Custom Tip sheet: mode toggles, keypad buttons.
    static let sheetControl: CGFloat = 12

    /// Split breakdown: small inline chips / weight controls (when not using `card`).
    static let breakdownCompact: CGFloat = 10

    // MARK: - Split Type (~16–18pt mockup)

    /// Even Split / % Weighted segments (squircle — not a full stadium capsule).
    static let splitTypeSegment: CGFloat = 17

    // MARK: - Primary CTA

    /// Shared primary action height for non-dashboard solid buttons (e.g. Done/Confirm rows).
    static let primaryButtonHeight: CGFloat = 56

    /// Split dashboard CTA ("View Breakdown"/"Customize Split"): taller with soft rounded-rect corners.
    static let dashboardPrimaryButtonHeight: CGFloat = 64
    static let dashboardPrimaryButtonCorner: CGFloat = 24
}
