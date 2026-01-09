//
//  SplitDashboardView.swift
//  TabsUp-DEV
//
//  Created by Thomas Weschke on 09/01/2026.
//

import SwiftUI

struct SplitDashboardView: View {
    @StateObject private var viewModel = SplitViewModel()
    @State private var showEnterAmount = false
    @State private var showCurrencySettings = false
    @State private var showSplitBreakdown = false
    
    let tipOptions: [Double] = [0, 10, 15, 20, 25]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.darkBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Section
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Split")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text("Let's divide that bill fairly")
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
                        
                        // Total Bill Card
                        TotalBillCard(
                            amount: viewModel.billTotal,
                            currency: viewModel.selectedCurrency,
                            onTap: {
                                showEnterAmount = true
                            }
                        )
                        .padding(.horizontal, 20)
                        
                        // Tip Selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Add Tip")
                                .font(.headline)
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, 20)
                            
                            HStack(spacing: 12) {
                                ForEach(tipOptions, id: \.self) { tip in
                                    TipButton(
                                        title: tip == 0 ? "No Tip" : "\(Int(tip))%",
                                        isSelected: viewModel.tipPercentage == tip,
                                        action: {
                                            viewModel.tipPercentage = tip
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Number of People Card
                        NumberOfPeopleCard(
                            count: viewModel.numberOfPeople,
                            onDecrement: {
                                viewModel.updateNumberOfPeople(viewModel.numberOfPeople - 1)
                            },
                            onIncrement: {
                                viewModel.updateNumberOfPeople(viewModel.numberOfPeople + 1)
                            }
                        )
                        .padding(.horizontal, 20)
                        
                        // Split Type Toggle
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Split Type")
                                .font(.headline)
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, 20)
                            
                            HStack(spacing: 12) {
                                SplitTypeButton(
                                    title: "Even Split",
                                    isSelected: viewModel.splitType == .even,
                                    action: {
                                        viewModel.splitType = .even
                                    }
                                )
                                
                                SplitTypeButton(
                                    title: "% Weighted",
                                    isSelected: viewModel.splitType == .weighted,
                                    action: {
                                        viewModel.splitType = .weighted
                                        viewModel.resetPeople()
                                    }
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Result Display
                        if viewModel.billTotal > 0 {
                            if viewModel.splitType == .even {
                                EvenSplitResultCard(
                                    amount: viewModel.perPersonEven,
                                    currency: viewModel.selectedCurrency
                                )
                                .padding(.horizontal, 20)
                            } else {
                                WeightedSplitResultCard(
                                    range: viewModel.weightedRange,
                                    currency: viewModel.selectedCurrency,
                                    onCustomize: {
                                        showSplitBreakdown = true
                                    }
                                )
                                .padding(.horizontal, 20)
                                .onAppear {
                                    // Ensure people are initialized for weighted split
                                    if viewModel.people.isEmpty {
                                        viewModel.resetPeople()
                                    }
                                }
                            }
                        }
                        
                        // View Breakdown Button (for even split)
                        if viewModel.splitType == .even && viewModel.billTotal > 0 {
                            Button(action: {
                                showSplitBreakdown = true
                            }) {
                                HStack {
                                    Text("View Breakdown")
                                        .font(.headline)
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                }
                                .foregroundColor(AppColors.buttonText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(AppColors.buttonBackground)
                                .cornerRadius(16)
                            }
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
        .fullScreenCover(isPresented: $showSplitBreakdown) {
            NavigationView {
                SplitBreakdownView(viewModel: viewModel)
            }
        }
    }
}

struct TotalBillCard: View {
    let amount: Double
    let currency: Currency
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                // Green Dollar Icon
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.greenIcon)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text("$")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Bill")
                        .font(.subheadline)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(String(format: "%@%.2f", currency.symbol, amount))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                }
                
                Spacer()
                
                // Scan Button
                Button(action: {
                    // Scan functionality (UI only for now)
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "camera.fill")
                            .font(.caption)
                        Text("Scan")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(AppColors.buttonText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(AppColors.greenIcon)
                    .cornerRadius(8)
                }
            }
            .padding()
            .background(AppColors.cardBackground)
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}

struct TipButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? AppColors.buttonText : AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(isSelected ? AppColors.buttonBackground : AppColors.cardBackground)
                .cornerRadius(12)
        }
    }
}

struct NumberOfPeopleCard: View {
    let count: Int
    let onDecrement: () -> Void
    let onIncrement: () -> Void
    
    var body: some View {
        HStack {
            // Purple People Icon
            RoundedRectangle(cornerRadius: 8)
                .fill(AppColors.purpleIcon)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "person.2.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Number of People")
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                
                HStack(spacing: 16) {
                    // Decrement Button
                    Button(action: onDecrement) {
                        Image(systemName: "minus")
                            .font(.headline)
                            .foregroundColor(AppColors.primaryText)
                            .frame(width: 36, height: 36)
                            .background(AppColors.purpleIcon.opacity(0.3))
                            .clipShape(Circle())
                    }
                    
                    VStack(spacing: 2) {
                        Text("\(count)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        Text("people")
                            .font(.caption)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    // Increment Button
                    Button(action: onIncrement) {
                        Image(systemName: "plus")
                            .font(.headline)
                            .foregroundColor(AppColors.primaryText)
                            .frame(width: 36, height: 36)
                            .background(AppColors.purpleIcon.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}

struct SplitTypeButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? AppColors.buttonText : AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(isSelected ? AppColors.buttonBackground : AppColors.cardBackground)
                .cornerRadius(12)
        }
    }
}

struct EvenSplitResultCard: View {
    let amount: Double
    let currency: Currency
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Per person (even)")
                .font(.caption)
                .foregroundColor(AppColors.secondaryText)
            
            Text(String(format: "%@%.2f", currency.symbol, amount))
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(AppColors.primaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}

struct WeightedSplitResultCard: View {
    let range: (min: Double, max: Double)
    let currency: Currency
    let onCustomize: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Range (weighted)")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
                
                Text(String(format: "%@%.2f - %@%.2f", currency.symbol, range.min, currency.symbol, range.max))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
            }
            
            Button(action: onCustomize) {
                HStack {
                    Text("Customize Split")
                        .font(.headline)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                }
                .foregroundColor(AppColors.buttonText)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(AppColors.buttonBackground)
                .cornerRadius(16)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}

#Preview {
    SplitDashboardView()
}
