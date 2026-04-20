//
//  DashboardPagerView.swift
//  TabsUp
//
//  Horizontal paging: Split and Tip dashboards share one SplitViewModel.
//

import SwiftUI
import UIKit

struct DashboardPagerView: View {
    @StateObject private var splitViewModel = SplitViewModel()
    @State private var selectedPage = 0
    @State private var selectionFeedback = UISelectionFeedbackGenerator()

    var body: some View {
        TabView(selection: $selectedPage) {
            SplitDashboardView(viewModel: splitViewModel, pagerSelectedPage: $selectedPage)
                .tag(0)
            TipDashboardView(viewModel: splitViewModel, pagerSelectedPage: $selectedPage)
                .tag(1)
        }
        .background(DashboardCanvasBackground())
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: selectedPage) { _, _ in
            selectionFeedback.prepare()
            selectionFeedback.selectionChanged()
        }
    }
}

#Preview {
    DashboardPagerView()
        .preferredColorScheme(.dark)
}
