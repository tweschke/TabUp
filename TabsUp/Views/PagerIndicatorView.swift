//
//  PagerIndicatorView.swift
//  TabsUp
//
//  Minimal swipe hint for dashboard paging (not system page dots).
//

import SwiftUI

struct PagerIndicatorView: View {
    @Binding var selection: Int
    let pageCount: Int
    var alignment: HorizontalAlignment = .center
    @Environment(\.colorScheme) private var colorScheme

    private var frameAlignment: Alignment {
        switch alignment {
        case .leading: return .leading
        case .trailing: return .trailing
        default: return .center
        }
    }

    private var springAnimation: Animation {
        .spring(response: DesignMotion.pagerSpringResponse, dampingFraction: DesignMotion.pagerSpringDamping)
    }

    private func dotFill(for index: Int) -> Color {
        if index == selection { return AppColors.tealAccent }
        return AppColors.pagerDotUnselected(for: colorScheme)
    }

    var body: some View {
        HStack(spacing: DesignLayout.pagerDotSpacing) {
            ForEach(0..<pageCount, id: \.self) { index in
                Button {
                    guard index != selection else { return }
                    withAnimation(springAnimation) {
                        selection = index
                    }
                } label: {
                    Capsule()
                        .fill(dotFill(for: index))
                        .frame(
                            width: index == selection ? DesignLayout.pagerDotActiveWidth : DesignLayout.pagerDotInactiveSize,
                            height: DesignLayout.pagerDotHeight
                        )
                }
                .buttonStyle(.plain)
                .padding(.vertical, DesignSpacing.tight)
                .padding(.horizontal, DesignSpacing.tight)
                .accessibilityLabel("Dashboard page \(index + 1) of \(pageCount)")
            }
        }
        .frame(maxWidth: .infinity, alignment: frameAlignment)
        .animation(springAnimation, value: selection)
    }
}

#Preview {
    VStack(spacing: DesignSpacing.preview) {
        PagerIndicatorView(selection: .constant(0), pageCount: 2)
        PagerIndicatorView(selection: .constant(1), pageCount: 2)
    }
    .padding(DesignSpacing.insetDefault)
    .background(AppColors.primaryBackground)
    .preferredColorScheme(.dark)
}
