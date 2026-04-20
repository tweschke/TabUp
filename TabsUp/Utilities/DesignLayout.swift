//
//  DesignLayout.swift
//  TabsUp
//
//  Fixed layout metrics (frames, hit targets, non-radius geometry).
//

import CoreGraphics

enum DesignLayout {
    /// Minimum touch target (settings, steppers, sheet toggles).
    static let touchTarget: CGFloat = 44

    /// Currency code pill on Total Bill (matches chip proportions).
    static let currencyPillWidth: CGFloat = 78
    static let currencyPillHeight: CGFloat = 40

    /// Purple “people” tile on Number of People card.
    static let peopleIconTile: CGFloat = 40

    /// Split type segment row height.
    static let splitTypeRowHeight: CGFloat = 48

    /// Horizontal inset inside split-type segment (icon + label).
    static let splitTypeHorizontalInset: CGFloat = 4

    /// Even Split asset / fallback icon bounds.
    static let splitTypeIconWidth: CGFloat = 30
    static let splitTypeIconHeight: CGFloat = 22

    /// Per-person decorative icon on result card.
    /// Increased to better match mockup emphasis and visual hierarchy.
    static let perPersonBillIcon: CGFloat = 68

    /// Count between − / + on Number of People.
    static let stepperCountMinWidth: CGFloat = 80

    /// Numeric keypad row (Enter Amount, Custom Tip).
    static let keypadRowHeight: CGFloat = 60

    /// Weighted breakdown ± control.
    static let breakdownStepper: CGFloat = 36

    /// Split method toggle (Shares / Percentages) height.
    static let breakdownMethodRowHeight: CGFloat = 40

    /// Minimum width for share/percentage value column.
    static let breakdownValueMinWidth: CGFloat = 40

    // MARK: - Pager dots

    static let pagerDotActiveWidth: CGFloat = 18
    static let pagerDotInactiveSize: CGFloat = 6
    static let pagerDotHeight: CGFloat = 4
    static let pagerDotSpacing: CGFloat = 6

    /// 1pt separators (e.g. Tip totals).
    static let hairlineHeight: CGFloat = 1

    // MARK: - Even Split fallback icon offsets

    static let evenIconRearOffsetX: CGFloat = 5
    static let evenIconRearOffsetY: CGFloat = 1
    static let evenIconFrontOffsetX: CGFloat = -4
    static let evenIconFrontOffsetY: CGFloat = -1

    // MARK: - Canvas background gradient

    /// Mid stop along the top-leading → bottom-trailing axis (light mode wash).
    static let canvasGradientMidLocation: CGFloat = 0.42

    /// Gradient endpoint stops (SwiftUI `LinearGradient` locations).
    static let gradientStopStart: CGFloat = 0
    static let gradientStopEnd: CGFloat = 1
}
