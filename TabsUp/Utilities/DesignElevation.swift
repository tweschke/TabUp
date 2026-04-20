//
//  DesignElevation.swift
//  TabsUp
//
//  Shadow parameters — single source for card lift and control depth.
//

import CoreGraphics
import SwiftUI

enum DesignElevation {
    /// Base for drop shadows (multiply by opacity constants in nested enums).
    static var shadowBase: Color { Color.black }

    /// Split dashboard primary cards (Total Bill surface, People, results) — paired layers.
    enum SplitPrimaryCard {
        static let upperOpacity: CGFloat = 0.06
        static let upperRadius: CGFloat = 12
        static let upperY: CGFloat = 6
        static let lowerOpacity: CGFloat = 0.03
        static let lowerRadius: CGFloat = 2
        static let lowerY: CGFloat = 1
    }

    /// Large white cards (`dashboardCardSurface`) — single lift in light mode.
    enum DashboardCard {
        static let liftOpacityLight: CGFloat = 0.14
        static let liftRadius: CGFloat = 18
        static let liftY: CGFloat = 8
    }

    /// Primary CTA pill (light).
    enum PrimaryCTA {
        static let shadowOpacityLight: CGFloat = 0.1
        static let shadowRadius: CGFloat = 10
        static let shadowY: CGFloat = 4
    }

    /// Circular icon buttons (settings).
    enum CircularIcon {
        static let shadowOpacityLight: CGFloat = 0.06
        static let shadowRadius: CGFloat = 6
        static let shadowY: CGFloat = 1
    }

    /// Currency pill on Total Bill (light).
    enum CurrencyPill {
        static let upperOpacity: CGFloat = 0.04
        static let upperRadius: CGFloat = 4
        static let upperY: CGFloat = 2
        static let lowerOpacity: CGFloat = 0.02
        static let lowerRadius: CGFloat = 1
        static let lowerY: CGFloat = 1
    }

    /// Add Tip chips (light).
    enum TipChip {
        static let upperRadiusSelected: CGFloat = 4
        static let upperRadiusUnselected: CGFloat = 5
        static let upperY: CGFloat = 2
        static let lowerRadius: CGFloat = 1
        static let lowerY: CGFloat = 1
    }

    /// Unselected split-type segment (light) — soft depth.
    enum SplitTypeInactive {
        static let upperOpacity: CGFloat = 0.07
        static let upperRadius: CGFloat = 8
        static let upperY: CGFloat = 4
        static let lowerOpacity: CGFloat = 0.04
        static let lowerRadius: CGFloat = 2
        static let lowerY: CGFloat = 1
    }
}

extension View {
    /// Two-layer shadow used for split primary cards (matches `DashboardSplitPrimaryCardSurfaceModifier`).
    func designSplitPrimaryCardShadow() -> some View {
        shadow(color: DesignElevation.shadowBase.opacity(DesignElevation.SplitPrimaryCard.upperOpacity), radius: DesignElevation.SplitPrimaryCard.upperRadius, x: 0, y: DesignElevation.SplitPrimaryCard.upperY)
            .shadow(color: DesignElevation.shadowBase.opacity(DesignElevation.SplitPrimaryCard.lowerOpacity), radius: DesignElevation.SplitPrimaryCard.lowerRadius, x: 0, y: DesignElevation.SplitPrimaryCard.lowerY)
    }

    func designCurrencyPillShadow() -> some View {
        shadow(color: DesignElevation.shadowBase.opacity(DesignElevation.CurrencyPill.upperOpacity), radius: DesignElevation.CurrencyPill.upperRadius, x: 0, y: DesignElevation.CurrencyPill.upperY)
            .shadow(color: DesignElevation.shadowBase.opacity(DesignElevation.CurrencyPill.lowerOpacity), radius: DesignElevation.CurrencyPill.lowerRadius, x: 0, y: DesignElevation.CurrencyPill.lowerY)
    }

    func designDashboardCardLiftShadow(colorScheme: ColorScheme) -> some View {
        shadow(
            color: colorScheme == .light ? DesignElevation.shadowBase.opacity(DesignElevation.DashboardCard.liftOpacityLight) : .clear,
            radius: colorScheme == .light ? DesignElevation.DashboardCard.liftRadius : 0,
            x: 0,
            y: colorScheme == .light ? DesignElevation.DashboardCard.liftY : 0
        )
    }

    func designPrimaryCTAShadow(colorScheme: ColorScheme) -> some View {
        shadow(
            color: colorScheme == .light ? DesignElevation.shadowBase.opacity(DesignElevation.PrimaryCTA.shadowOpacityLight) : .clear,
            radius: colorScheme == .light ? DesignElevation.PrimaryCTA.shadowRadius : 0,
            x: 0,
            y: colorScheme == .light ? DesignElevation.PrimaryCTA.shadowY : 0
        )
    }

    func designCircularIconShadow(colorScheme: ColorScheme) -> some View {
        shadow(
            color: colorScheme == .light ? DesignElevation.shadowBase.opacity(DesignElevation.CircularIcon.shadowOpacityLight) : .clear,
            radius: colorScheme == .light ? DesignElevation.CircularIcon.shadowRadius : 0,
            x: 0,
            y: colorScheme == .light ? DesignElevation.CircularIcon.shadowY : 0
        )
    }
}
