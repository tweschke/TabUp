//
//  DashboardChrome.swift
//  TabsUp
//
//  Phase 2: shared visual chrome for dashboard surfaces (light elevation, dark parity).
//  Phase 3: dashboard canvas + branded primary CTA (teal–purple gradient, restrained).
//

import SwiftUI

// MARK: - Dashboard canvas (light: subtle tint; dark: flat base)

struct DashboardCanvasBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            AppColors.primaryBackground
            if colorScheme == .light {
                LinearGradient(
                    stops: [
                        .init(color: AppColors.tealAccent.opacity(DesignOpacity.canvasTealWashLight), location: DesignLayout.gradientStopStart),
                        .init(color: Color.clear, location: DesignLayout.canvasGradientMidLocation),
                        .init(color: AppColors.purpleAccent.opacity(DesignOpacity.canvasPurpleWashLight), location: DesignLayout.gradientStopEnd)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Primary CTA (full-width main actions)

struct DashboardPrimaryCTAModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .foregroundColor(AppColors.buttonText)
            .frame(maxWidth: .infinity)
            .frame(height: DesignRadius.dashboardPrimaryButtonHeight)
            .background(ctaFill)
            .clipShape(RoundedRectangle(cornerRadius: DesignRadius.dashboardPrimaryButtonCorner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignRadius.dashboardPrimaryButtonCorner, style: .continuous)
                    .strokeBorder(
                        Color.white.opacity(colorScheme == .light ? DesignOpacity.ctaCapsuleBorderLight : DesignOpacity.ctaCapsuleBorderDark),
                        lineWidth: DesignStroke.hairline
                    )
            )
            .designPrimaryCTAShadow(colorScheme: colorScheme)
    }

    private var ctaFill: some View {
        AppColors.gradient(colorScheme: colorScheme)
    }
}

// MARK: - Card surfaces

struct DashboardCardSurfaceModifier: ViewModifier {
    var cornerRadius: CGFloat
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(AppColors.borderSubtle, lineWidth: DesignStroke.hairline)
            )
            .designDashboardCardLiftShadow(colorScheme: colorScheme)
    }
}

/// Split dashboard primary cards (Total Bill uses `TotalBillCardSurfaceModifier`; People + Result use this).
struct DashboardSplitPrimaryCardSurfaceModifier: ViewModifier {
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(AppColors.borderSubtle, lineWidth: DesignStroke.hairline)
            )
            .designSplitPrimaryCardShadow()
    }
}

struct DashboardCircularIconSurfaceModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background(AppColors.cardBackground)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .strokeBorder(AppColors.borderSubtle, lineWidth: DesignStroke.hairline)
            )
            .designCircularIconShadow(colorScheme: colorScheme)
    }
}

// MARK: - Press feedback (chips, dashboard tappable rows)

/// Spring scale for dashboard chips, split controls, and primary CTAs (no layout change).
struct DashboardSubtlePressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? DesignMotion.subtlePressScale : 1)
            .animation(
                .spring(response: DesignMotion.subtlePressResponse, dampingFraction: DesignMotion.subtlePressDamping),
                value: configuration.isPressed
            )
    }
}

extension View {
    /// Primary dashboard cards: subtle lift in light mode only; stroke + fill in both modes.
    func dashboardCardSurface(cornerRadius: CGFloat = DesignRadius.card) -> some View {
        modifier(DashboardCardSurfaceModifier(cornerRadius: cornerRadius))
    }

    /// Split dashboard: People + Result cards (paired elevation shadows; Tip tab cards keep `dashboardCardSurface`).
    func splitDashboardPrimaryCardSurface(cornerRadius: CGFloat = DesignRadius.card) -> some View {
        modifier(DashboardSplitPrimaryCardSurfaceModifier(cornerRadius: cornerRadius))
    }

    /// Compact circular controls (e.g. settings) aligned with card elevation.
    func dashboardCircularIconSurface() -> some View {
        modifier(DashboardCircularIconSurfaceModifier())
    }

    /// Full-width branded primary action (Split: View Breakdown / Customize; sheets: Confirm Tip).
    func dashboardPrimaryCTA() -> some View {
        modifier(DashboardPrimaryCTAModifier())
    }
}
