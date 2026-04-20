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
            AppColors.primaryBackground
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
        VStack(spacing: DesignSpacing.stackFlush) {
            // Total Bill Card
            VStack(spacing: DesignSpacing.compact) {
                Text("Total Bill")
                    .font(.headline)
                    .foregroundColor(AppColors.secondaryText)
                
                Text(formatCurrency(viewModel.totalWithTip))
                    .font(DesignTypography.dashboardScreenTitle)
                    .foregroundColor(AppColors.primaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignSpacing.section)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignRadius.card, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignRadius.card, style: .continuous)
                    .stroke(AppColors.borderSubtle, lineWidth: DesignStroke.hairline)
            )
            .padding(.horizontal, DesignSpacing.screenHorizontal)
            .padding(.top, DesignSpacing.screenHorizontal)
            
            // Per Person Amount Card
            VStack(spacing: DesignSpacing.compact) {
                Text("Per Person")
                    .font(.headline)
                    .foregroundColor(AppColors.secondaryText)
                
                Text(formatCurrency(viewModel.perPersonEven))
                    .font(DesignTypography.largeMetric)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Split evenly among \(viewModel.numberOfPeople) \(viewModel.numberOfPeople == 1 ? "person" : "people")")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
                    .padding(.top, DesignSpacing.tight)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignSpacing.section)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignRadius.card, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignRadius.card, style: .continuous)
                    .stroke(AppColors.borderSubtle, lineWidth: DesignStroke.hairline)
            )
            .padding(.horizontal, DesignSpacing.screenHorizontal)
            .padding(.top, DesignSpacing.section)
            
            // People List (Read-only)
            ScrollView {
                VStack(spacing: DesignSpacing.subsection) {
                    ForEach(viewModel.people) { person in
                        EvenSplitPersonCard(
                            person: person,
                            currency: viewModel.selectedCurrency,
                            perPersonAmount: viewModel.perPersonEven
                        )
                    }
                }
                .padding(.horizontal, DesignSpacing.screenHorizontal)
                .padding(.top, DesignSpacing.section)
            }
            
            Spacer()
            
            // Start New Split Button
            Button(action: {
                viewModel.startNewSplit()
                dismiss()
            }) {
                HStack(spacing: DesignSpacing.compact) {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                    Text("Start New Split")
                        .font(.subheadline)
                }
                .foregroundColor(AppColors.secondaryText)
            }
            .padding(.bottom, DesignSpacing.listRowCompact)
            
            // Done Button
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: DesignSpacing.compact) {
                    Image(systemName: "checkmark")
                        .font(.headline)
                    Text("Done")
                        .font(.headline)
                }
                .foregroundColor(AppColors.buttonText)
                .frame(maxWidth: .infinity)
                .frame(height: DesignRadius.primaryButtonHeight)
                .background(AppColors.buttonBackground)
                .clipShape(Capsule(style: .continuous))
            }
            .padding(.horizontal, DesignSpacing.screenHorizontal)
            .padding(.bottom, DesignSpacing.screenBottom)
        }
    }
    
    // MARK: - Weighted Split View
    
    private var weightedSplitView: some View {
        VStack(spacing: DesignSpacing.stackFlush) {
            // Total Bill Card
            VStack(spacing: DesignSpacing.compact) {
                Text("Total Bill")
                    .font(.headline)
                    .foregroundColor(AppColors.secondaryText)
                
                Text(formatCurrency(viewModel.totalWithTip))
                    .font(DesignTypography.dashboardScreenTitle)
                    .foregroundColor(AppColors.primaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignSpacing.section)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignRadius.card, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignRadius.card, style: .continuous)
                    .stroke(AppColors.borderSubtle, lineWidth: DesignStroke.hairline)
            )
            .padding(.horizontal, DesignSpacing.screenHorizontal)
            .padding(.top, DesignSpacing.screenHorizontal)
            
            // Split Method Toggle
            HStack(spacing: DesignSpacing.related) {
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
            .padding(.horizontal, DesignSpacing.screenHorizontal)
            .padding(.top, DesignSpacing.section)
            
            // Instruction Text
            Text(splitMethod == .shares ? "Tap +/- to adjust shares" : "Adjust percentages")
                .font(.caption)
                .foregroundColor(AppColors.secondaryText)
                .padding(.top, DesignSpacing.listRowCompact)
                .padding(.horizontal, DesignSpacing.screenHorizontal)
            
            // People List
            ScrollView {
                VStack(spacing: DesignSpacing.subsection) {
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
                .padding(.horizontal, DesignSpacing.screenHorizontal)
                .padding(.top, DesignSpacing.section)
            }
            
            Spacer()
            
            // Start New Split Button
            Button(action: {
                viewModel.startNewSplit()
                dismiss()
            }) {
                HStack(spacing: DesignSpacing.compact) {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                    Text("Start New Split")
                        .font(.subheadline)
                }
                .foregroundColor(AppColors.secondaryText)
            }
            .padding(.bottom, DesignSpacing.listRowCompact)
            
            // Done Button
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: DesignSpacing.compact) {
                    Image(systemName: "checkmark")
                        .font(.headline)
                    Text("Done")
                        .font(.headline)
                }
                .foregroundColor(AppColors.buttonText)
                .frame(maxWidth: .infinity)
                .frame(height: DesignRadius.primaryButtonHeight)
                .background(AppColors.buttonBackground)
                .clipShape(Capsule(style: .continuous))
            }
            .padding(.horizontal, DesignSpacing.screenHorizontal)
            .padding(.bottom, DesignSpacing.screenBottom)
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
                .frame(height: DesignLayout.breakdownMethodRowHeight)
                .background(isSelected ? AppColors.buttonBackground : AppColors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: DesignRadius.breakdownCompact, style: .continuous))
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
        VStack(alignment: .leading, spacing: DesignSpacing.subsection) {
            // First Row: Avatar + Name on left, Amount on right
            HStack {
                HStack(spacing: DesignSpacing.related) {
                    // Avatar
                    Circle()
                        .fill(person.name == "You" ? AppColors.greenIcon : AppColors.purpleIcon)
                        .frame(width: DesignLayout.touchTarget, height: DesignLayout.touchTarget)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(AppColors.buttonText)
                                .font(DesignTypography.weightStepperGlyph)
                        )
                    
                    // Name
                    Text(person.name)
                        .font(.headline)
                        .foregroundColor(AppColors.primaryText)
                }
                
                Spacer()
                
                // Amount
                Text(String(format: "%@%.2f", currency.symbol, person.amount))
                    .font(DesignTypography.cardInlineIcon)
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
                    .frame(minWidth: DesignLayout.breakdownValueMinWidth)
                
                Spacer()
                
                // Adjustment Buttons
                HStack(spacing: DesignSpacing.related) {
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
                            .frame(width: DesignLayout.breakdownStepper, height: DesignLayout.breakdownStepper)
                            .background((person.name == "You" ? AppColors.greenIcon : AppColors.purpleIcon).opacity(DesignOpacity.avatarBadge))
                            .clipShape(RoundedRectangle(cornerRadius: DesignRadius.breakdownCompact, style: .continuous))
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
                            .frame(width: DesignLayout.breakdownStepper, height: DesignLayout.breakdownStepper)
                            .background((person.name == "You" ? AppColors.greenIcon : AppColors.purpleIcon).opacity(DesignOpacity.avatarBadge))
                            .clipShape(RoundedRectangle(cornerRadius: DesignRadius.breakdownCompact, style: .continuous))
                    }
                }
            }
        }
        .padding(DesignSpacing.insetDefault)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignRadius.card, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignRadius.card, style: .continuous)
                .stroke(AppColors.borderSubtle, lineWidth: DesignStroke.hairline)
        )
    }
}

struct EvenSplitPersonCard: View {
    let person: Person
    let currency: Currency
    let perPersonAmount: Double
    
    var body: some View {
        HStack(spacing: DesignSpacing.related) {
            // Avatar
            Circle()
                .fill(person.name == "You" ? AppColors.greenIcon : AppColors.purpleIcon)
                .frame(width: DesignLayout.touchTarget, height: DesignLayout.touchTarget)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(AppColors.buttonText)
                        .font(DesignTypography.weightStepperGlyph)
                )
            
            // Name
            Text(person.name)
                .font(.headline)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            // Amount (read-only)
            Text(String(format: "%@%.2f", currency.symbol, perPersonAmount))
                .font(DesignTypography.cardInlineIcon)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.primaryText)
        }
        .padding(DesignSpacing.insetDefault)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignRadius.card, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignRadius.card, style: .continuous)
                .stroke(AppColors.borderSubtle, lineWidth: DesignStroke.hairline)
        )
    }
}

#Preview {
    NavigationView {
        SplitBreakdownView(viewModel: SplitViewModel())
    }
}
