//
//  TipDashboardView.swift
//  TabsUp
//
//  Phase 1: single-user tip calculator; shares SplitViewModel with Split dashboard.
//

import SwiftUI

struct TipDashboardView: View {
    @ObservedObject var viewModel: SplitViewModel
    var pagerSelectedPage: Binding<Int>
    @Environment(\.colorScheme) private var colorScheme
    @State private var showEnterAmount = false
    @State private var showCurrencySettings = false
    @State private var showCustomTip = false
    
    let tipOptions: [Double] = [0, 10, 15, 20, 25]
    
    private var isTipSelected: (Double) -> Bool {
        { tip in
            switch viewModel.tipType {
            case .percentage(let percentage):
                return percentage == tip && !viewModel.isCustomTip
            case .fixedAmount:
                return false
            }
        }
    }
    
    private var isCustomTipSelected: Bool {
        viewModel.isCustomTip
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                DashboardCanvasBackground()
                
                ScrollView {
                    VStack(spacing: DesignSpacing.stackFlush) {
                        VStack(spacing: DesignSpacing.compact) {
                            HStack(alignment: .top, spacing: DesignSpacing.related) {
                                VStack(alignment: .leading, spacing: DesignSpacing.titleGroup) {
                                    Text("Tip")
                                        .font(DesignTypography.dashboardScreenTitle)
                                        .foregroundColor(AppColors.primaryText)

                                    Text("Let's add a fair tip")
                                        .font(.subheadline)
                                        .foregroundColor(
                                            colorScheme == .light
                                                ? AppColors.primaryText.opacity(DesignOpacity.subtitleOnLight)
                                                : AppColors.secondaryText
                                        )
                                }

                                Spacer(minLength: DesignSpacing.spacerMinCollapsed)

                                Button(action: {
                                    showCurrencySettings = true
                                }) {
                                    Image(systemName: "line.3.horizontal")
                                        .font(DesignTypography.dashboardBarButton)
                                        .foregroundColor(AppColors.primaryText)
                                        .frame(width: DesignLayout.touchTarget, height: DesignLayout.touchTarget)
                                        .dashboardCircularIconSurface()
                                }
                                .buttonStyle(DashboardSubtlePressButtonStyle())
                                .accessibilityLabel("Settings")
                            }

                            PagerIndicatorView(selection: pagerSelectedPage, pageCount: 2)
                        }
                        .padding(.horizontal, DesignSpacing.screenHorizontal)
                        .padding(.top, DesignSpacing.headerTop)

                        TotalBillCard(
                            amount: viewModel.billTotal,
                            currency: viewModel.selectedCurrency,
                            onTap: {
                                showEnterAmount = true
                            },
                            onCurrencyTap: {
                                showCurrencySettings = true
                            }
                        )
                        .padding(.horizontal, DesignSpacing.screenHorizontal)
                        .padding(.top, DesignSpacing.pagerToFirstCard)

                        VStack(spacing: DesignSpacing.section) {
                            VStack(alignment: .leading, spacing: DesignSpacing.related) {
                                Text("Add Tip")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.horizontal, DesignSpacing.screenHorizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: DesignSpacing.related) {
                                        ForEach(tipOptions, id: \.self) { tip in
                                            TipButton(
                                                title: tip == 0 ? "No Tip" : "\(Int(tip))%",
                                                isSelected: isTipSelected(tip),
                                                action: {
                                                    viewModel.setTipPercentage(tip)
                                                }
                                            )
                                        }
                                        
                                        TipButton(
                                            title: getCustomTipTitle(),
                                            isSelected: isCustomTipSelected,
                                            action: {
                                                showCustomTip = true
                                            }
                                        )
                                    }
                                    .padding(.horizontal, DesignSpacing.screenHorizontal)
                                }
                            }
                            
                            if viewModel.billTotal > 0 {
                                TipTotalsResultCard(
                                    tipAmount: viewModel.tipAmount,
                                    totalWithTip: viewModel.totalWithTip,
                                    currency: viewModel.selectedCurrency
                                )
                                .padding(.horizontal, DesignSpacing.screenHorizontal)
                                .padding(.bottom, DesignSpacing.screenBottom)
                            }
                        }
                        .padding(.top, DesignSpacing.section)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showEnterAmount) {
            EnterAmountView(
                amount: $viewModel.billTotal,
                isPresented: $showEnterAmount,
                currency: viewModel.selectedCurrency
            )
        }
        .sheet(isPresented: $showCurrencySettings) {
            CurrencySettingsView(viewModel: viewModel)
        }
        .sheet(isPresented: $showCustomTip) {
            CustomTipView(
                viewModel: viewModel,
                isPresented: $showCustomTip
            )
        }
    }
    
    private func getCustomTipTitle() -> String {
        switch viewModel.tipType {
        case .percentage(let percentage):
            if viewModel.isCustomTip {
                return String(format: "%.0f%%", percentage)
            }
            return "Custom"
        case .fixedAmount(let amount):
            return String(format: "%@%.2f", viewModel.selectedCurrency.symbol, amount)
        }
    }
}

// MARK: - Tip summary (single payer)

private struct TipTotalsResultCard: View {
    let tipAmount: Double
    let totalWithTip: Double
    let currency: Currency
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSpacing.compact) {
            VStack(alignment: .leading, spacing: DesignSpacing.compact) {
                Text("Tip amount")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
                
                Text(String(format: "%@%.2f", currency.symbol, tipAmount))
                    .font(DesignTypography.tipSummaryPrimary)
                    .foregroundColor(AppColors.primaryText)
            }
            
            Rectangle()
                .fill(AppColors.borderSubtle.opacity(DesignOpacity.dividerMuted))
                .frame(height: DesignLayout.hairlineHeight)
                .padding(.vertical, DesignSpacing.tight)
            
            VStack(alignment: .leading, spacing: DesignSpacing.compact) {
                Text("Total with tip")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
                
                Text(String(format: "%@%.2f", currency.symbol, totalWithTip))
                    .font(DesignTypography.largeMetric)
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignSpacing.insetDefault)
        .dashboardCardSurface()
    }
}

#Preview {
    TipDashboardView(viewModel: SplitViewModel(), pagerSelectedPage: .constant(0))
        .preferredColorScheme(.dark)
}
