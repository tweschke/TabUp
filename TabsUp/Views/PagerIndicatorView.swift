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

    private var springAnimation: Animation {
        .spring(response: 0.32, dampingFraction: 0.78)
    }

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<pageCount, id: \.self) { index in
                Button {
                    guard index != selection else { return }
                    withAnimation(springAnimation) {
                        selection = index
                    }
                } label: {
                    Capsule()
                        .fill(index == selection ? AppColors.tealAccent : AppColors.secondaryText.opacity(0.35))
                        .frame(width: index == selection ? 18 : 6, height: 4)
                }
                .buttonStyle(.plain)
                .padding(.vertical, 8)
                .padding(.horizontal, 4)
                .accessibilityLabel("Dashboard page \(index + 1) of \(pageCount)")
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .animation(springAnimation, value: selection)
    }
}

#Preview {
    VStack(spacing: 16) {
        PagerIndicatorView(selection: .constant(0), pageCount: 2)
        PagerIndicatorView(selection: .constant(1), pageCount: 2)
    }
    .padding()
    .background(AppColors.darkBackground)
    .preferredColorScheme(.dark)
}
