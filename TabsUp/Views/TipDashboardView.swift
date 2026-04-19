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
                AppColors.darkBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Tip")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text("Let's add a fair tip")
                                    .font(.subheadline)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showCurrencySettings = true
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .font(.title2)
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(width: 44, height: 44)
                                    .background(AppColors.cardBackground)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                        PagerIndicatorView(selection: pagerSelectedPage, pageCount: 2)
                            .padding(.top, 6)
                            .padding(.horizontal, 20)
                        
                        TotalBillCard(
                            amount: viewModel.billTotal,
                            currency: viewModel.selectedCurrency,
                            onTap: {
                                showEnterAmount = true
                            }
                        )
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Add Tip")
                                .font(.headline)
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
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
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        if viewModel.billTotal > 0 {
                            TipTotalsResultCard(
                                tipAmount: viewModel.tipAmount,
                                totalWithTip: viewModel.totalWithTip,
                                currency: viewModel.selectedCurrency
                            )
                            .padding(.horizontal, 20)
                            .padding(.bottom, 32)
                        }
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
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Tip amount")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
                
                Text(String(format: "%@%.2f", currency.symbol, tipAmount))
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Total with tip")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
                
                Text(String(format: "%@%.2f", currency.symbol, totalWithTip))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    TipDashboardView(viewModel: SplitViewModel(), pagerSelectedPage: .constant(0))
        .preferredColorScheme(.dark)
}
