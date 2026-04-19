//
//  SplitBreakdownView.swift
//  TabsUp
//
//  Created by Thomas Weschke on 09/01/2026.
//

import SwiftUI

struct SplitBreakdownView: View {
    @ObservedObject var viewModel: SplitViewModel
    @Environment(\.dismiss) var dismiss
    @State private var splitMethod: SplitMethod = .shares
    @State private var showShareSheet: Bool = false
    
    enum SplitMethod {
        case shares
        case percentages
    }
    
    var body: some View {
        ZStack {
            AppColors.darkBackground
                .ignoresSafeArea()
            
            if viewModel.splitType == .even {
                // Even Split Summary View
                evenSplitView
            } else {
                // Weighted Split View with adjustments
                weightedSplitView
            }
        }
        .onAppear {
            // Initialize people if needed
            if viewModel.people.isEmpty {
                viewModel.resetPeople()
            }
            // For even splits, ensure people array has correct count
            if viewModel.splitType == .even {
                // Ensure people array matches numberOfPeople
                if viewModel.people.count != viewModel.numberOfPeople {
                    viewModel.resetPeople()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppColors.primaryText)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Split Breakdown")
                    .font(.headline)
                    .foregroundColor(AppColors.primaryText)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            let shareText = generateShareContent()
            ShareSheetView(activityItemSource: ShareActivityItemSource(shareText: shareText))
        }
    }
    
    // MARK: - Even Split View
    
    private var evenSplitView: some View {
        VStack(spacing: 0) {
            // Total Bill Card
            VStack(spacing: 8) {
                Text("Total Bill")
                    .font(.headline)
                    .foregroundColor(AppColors.secondaryText)
                
                Text(formatCurrency(viewModel.totalWithTip))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Per Person Amount Card
            VStack(spacing: 8) {
                Text("Per Person")
                    .font(.headline)
                    .foregroundColor(AppColors.secondaryText)
                
                Text(formatCurrency(viewModel.perPersonEven))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Split evenly among \(viewModel.numberOfPeople) \(viewModel.numberOfPeople == 1 ? "person" : "people")")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.top, 24)
            
            // People List (Read-only)
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.people) { person in
                        EvenSplitPersonCard(
                            person: person,
                            currency: viewModel.selectedCurrency,
                            perPersonAmount: viewModel.perPersonEven
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
            }
            
            Spacer()
            
            // Start New Split Button
            Button(action: {
                viewModel.startNewSplit()
                dismiss()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                    Text("Start New Split")
                        .font(.subheadline)
                }
                .foregroundColor(AppColors.secondaryText)
            }
            .padding(.bottom, 8)
            
            // Done Button
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark")
                        .font(.headline)
                    Text("Done")
                        .font(.headline)
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
    
    // MARK: - Weighted Split View
    
    private var weightedSplitView: some View {
        VStack(spacing: 0) {
            // Total Bill Card
            VStack(spacing: 8) {
                Text("Total Bill")
                    .font(.headline)
                    .foregroundColor(AppColors.secondaryText)
                
                Text(formatCurrency(viewModel.totalWithTip))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Split Method Toggle
            HStack(spacing: 12) {
                SplitMethodButton(
                    title: "Shares",
                    isSelected: splitMethod == .shares
                ) {
                    splitMethod = .shares
                    viewModel.calculateWeightedSplit()
                }
                
                SplitMethodButton(
                    title: "Percentages",
                    isSelected: splitMethod == .percentages
                ) {
                    splitMethod = .percentages
                    viewModel.calculateWeightedSplitByPercentage()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            
            // Instruction Text
            Text(splitMethod == .shares ? "Tap +/- to adjust shares" : "Adjust percentages")
                .font(.caption)
                .foregroundColor(AppColors.secondaryText)
                .padding(.top, 8)
                .padding(.horizontal, 20)
            
            // People List
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.people) { person in
                        PersonCard(
                            person: person,
                            splitMethod: splitMethod,
                            currency: viewModel.selectedCurrency,
                            onSharesChange: { delta in
                                viewModel.updatePersonShares(person.id, delta: delta)
                            },
                            onPercentageChange: { delta in
                                viewModel.updatePersonPercentage(person.id, delta: delta)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
            }
            
            Spacer()
            
            // Start New Split Button
            Button(action: {
                viewModel.startNewSplit()
                dismiss()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                    Text("Start New Split")
                        .font(.subheadline)
                }
                .foregroundColor(AppColors.secondaryText)
            }
            .padding(.bottom, 8)
            
            // Done Button
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark")
                        .font(.headline)
                    Text("Done")
                        .font(.headline)
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
        .onAppear {
            // Calculate initial split
            if splitMethod == .shares {
                viewModel.calculateWeightedSplit()
            } else {
                viewModel.calculateWeightedSplitByPercentage()
            }
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        return String(format: "%@%.2f", viewModel.selectedCurrency.symbol, amount)
    }
    
    private func generateShareContent() -> String {
        let currency = viewModel.selectedCurrency
        let totalBill = viewModel.totalWithTip
        let tipAmount = viewModel.tipAmount
        
        var shareText = "Breakdown from TabsUp\n\n"
        shareText += "Total Bill: \(currency.symbol)\(String(format: "%.2f", totalBill))\n"
        
        // Add tip information if applicable
        if tipAmount > 0 {
            switch viewModel.tipType {
            case .percentage(let percentage):
                shareText += "Tip: \(currency.symbol)\(String(format: "%.2f", tipAmount)) (\(Int(percentage))%)\n"
            case .fixedAmount:
                shareText += "Tip: \(currency.symbol)\(String(format: "%.2f", tipAmount))\n"
            }
        }
        
        shareText += "\n"
        
        if viewModel.splitType == .even {
            shareText += "Even Split (\(viewModel.numberOfPeople) \(viewModel.numberOfPeople == 1 ? "person" : "people")):\n"
            shareText += "Per Person: \(currency.symbol)\(String(format: "%.2f", viewModel.perPersonEven))\n\n"
            shareText += "Individual Shares:\n"
            for person in viewModel.people {
                shareText += "• \(person.name): \(currency.symbol)\(String(format: "%.2f", viewModel.perPersonEven))\n"
            }
        } else {
            shareText += "Individual Shares:\n"
            for person in viewModel.people {
                shareText += "• \(person.name): \(currency.symbol)\(String(format: "%.2f", person.amount))\n"
            }
        }
        
        shareText += "\nLet's get this settled! 💸"
        return shareText
    }
}

struct SplitMethodButton: View {
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
                .frame(height: 40)
                .background(isSelected ? AppColors.buttonBackground : AppColors.cardBackground)
                .cornerRadius(8)
        }
    }
}

struct PersonCard: View {
    let person: Person
    let splitMethod: SplitBreakdownView.SplitMethod
    let currency: Currency
    let onSharesChange: (Int) -> Void
    let onPercentageChange: (Double) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // First Row: Avatar + Name on left, Amount on right
            HStack {
                HStack(spacing: 12) {
                    // Avatar
                    Circle()
                        .fill(person.name == "You" ? AppColors.greenIcon : AppColors.purpleIcon)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        )
                    
                    // Name
                    Text(person.name)
                        .font(.headline)
                        .foregroundColor(AppColors.primaryText)
                }
                
                Spacer()
                
                // Amount
                Text(String(format: "%@%.2f", currency.symbol, person.amount))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.primaryText)
            }
            
            // Second Row: Shares/Percentage controls - evenly distributed
            HStack {
                // Label
                Text(splitMethod == .shares ? "Shares" : "Percentage")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
                
                Spacer()
                
                // Value Display
                Text(splitMethod == .shares ? "\(person.shares)" : String(format: "%.0f%%", person.percentage))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.primaryText)
                    .frame(minWidth: 40)
                
                Spacer()
                
                // Adjustment Buttons
                HStack(spacing: 12) {
                    Button(action: {
                        if splitMethod == .shares {
                            onSharesChange(-1)
                        } else {
                            onPercentageChange(-1.0)
                        }
                    }) {
                        Image(systemName: "minus")
                            .font(.headline)
                            .foregroundColor(AppColors.primaryText)
                            .frame(width: 36, height: 36)
                            .background((person.name == "You" ? AppColors.greenIcon : AppColors.purpleIcon).opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Button(action: {
                        if splitMethod == .shares {
                            onSharesChange(1)
                        } else {
                            onPercentageChange(1.0)
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.headline)
                            .foregroundColor(AppColors.primaryText)
                            .frame(width: 36, height: 36)
                            .background((person.name == "You" ? AppColors.greenIcon : AppColors.purpleIcon).opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct EvenSplitPersonCard: View {
    let person: Person
    let currency: Currency
    let perPersonAmount: Double
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            Circle()
                .fill(person.name == "You" ? AppColors.greenIcon : AppColors.purpleIcon)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                )
            
            // Name
            Text(person.name)
                .font(.headline)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            // Amount (read-only)
            Text(String(format: "%@%.2f", currency.symbol, perPersonAmount))
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.primaryText)
        }
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
    NavigationView {
        SplitBreakdownView(viewModel: SplitViewModel())
    }
}
