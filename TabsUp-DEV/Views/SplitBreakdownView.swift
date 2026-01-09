//
//  SplitBreakdownView.swift
//  TabsUp-DEV
//
//  Created by Thomas Weschke on 09/01/2026.
//

import SwiftUI

struct SplitBreakdownView: View {
    @ObservedObject var viewModel: SplitViewModel
    @Environment(\.dismiss) var dismiss
    @State private var splitMethod: SplitMethod = .shares
    
    enum SplitMethod {
        case shares
        case percentages
    }
    
    var body: some View {
        ZStack {
            AppColors.darkBackground
                .ignoresSafeArea()
            
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
        }
        .onAppear {
            // Initialize people if needed
            if viewModel.people.isEmpty {
                viewModel.resetPeople()
            }
            // Calculate initial split
            if splitMethod == .shares {
                viewModel.calculateWeightedSplit()
            } else {
                viewModel.calculateWeightedSplitByPercentage()
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
                    // Share functionality
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        return String(format: "%@%.2f", viewModel.selectedCurrency.symbol, amount)
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
        HStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(person.name == "You" ? AppColors.greenIcon : AppColors.purpleIcon)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(person.name)
                    .font(.headline)
                    .foregroundColor(AppColors.primaryText)
                
                HStack(spacing: 8) {
                    Text(splitMethod == .shares ? "Shares" : "Percentage")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(splitMethod == .shares ? "\(person.shares)" : String(format: "%.0f%%", person.percentage))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.primaryText)
                    
                    // Adjustment Buttons
                    HStack(spacing: 8) {
                        Button(action: {
                            if splitMethod == .shares {
                                onSharesChange(-1)
                            } else {
                                onPercentageChange(-1.0)
                            }
                        }) {
                            Image(systemName: "minus")
                                .font(.caption)
                                .foregroundColor(AppColors.primaryText)
                                .frame(width: 28, height: 28)
                                .background(AppColors.cardBackground)
                                .cornerRadius(6)
                        }
                        
                        Button(action: {
                            if splitMethod == .shares {
                                onSharesChange(1)
                            } else {
                                onPercentageChange(1.0)
                            }
                        }) {
                            Image(systemName: "plus")
                                .font(.caption)
                                .foregroundColor(AppColors.primaryText)
                                .frame(width: 28, height: 28)
                                .background(AppColors.cardBackground)
                                .cornerRadius(6)
                        }
                    }
                }
            }
            
            Spacer()
            
            // Amount
            Text(String(format: "%@%.2f", currency.symbol, person.amount))
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.primaryText)
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}

#Preview {
    NavigationView {
        SplitBreakdownView(viewModel: SplitViewModel())
    }
}
