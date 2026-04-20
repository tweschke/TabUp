//
//  DesignStroke.swift
//  TabsUp
//
//  Border widths and common overlay opacities.
//

import CoreGraphics

enum DesignStroke {
    static let hairline: CGFloat = 1
    static let chipBorder: CGFloat = 1.25
    static let splitTypeSelected: CGFloat = 1.5

    /// Stroke width when no border should render (e.g. unselected chip overlay).
    static let hidden: CGFloat = 0
}

enum DesignOpacity {
    /// Light mode subtitle on primary (title block).
    static let subtitleOnLight: CGFloat = 0.50

    /// Sheet mode-toggle stroke over `borderSubtle`.
    static let borderSubtleSheet: CGFloat = 0.45

    /// Dark mode purple stepper fill tint.
    static let stepperPurpleDark: CGFloat = 0.28

    /// Breakdown avatar fill over brand colour.
    static let avatarBadge: CGFloat = 0.3

    /// Muted horizontal rules (e.g. Tip totals).
    static let dividerMuted: CGFloat = 0.55

    /// Primary CTA capsule highlight (light / dark).
    static let ctaCapsuleBorderLight: CGFloat = 0.2
    static let ctaCapsuleBorderDark: CGFloat = 0.12

    /// Tip chip upper shadow — selected.
    static let tipChipShadowUpperSelected: CGFloat = 0.04

    /// Tip chip upper shadow — unselected.
    static let tipChipShadowUpperUnselected: CGFloat = 0.05

    /// Tip chip micro shadow (second layer).
    static let tipChipShadowLower: CGFloat = 0.02

    /// Currency pill chevron — slightly muted vs primary label.
    static let currencyChevronMuted: CGFloat = 0.75

    /// Light canvas diagonal wash: teal stop (`DashboardCanvasBackground`).
    static let canvasTealWashLight: CGFloat = 0.05

    /// Light canvas diagonal wash: purple stop.
    static let canvasPurpleWashLight: CGFloat = 0.04
}
