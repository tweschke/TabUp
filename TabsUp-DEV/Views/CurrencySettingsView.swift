//
//  CurrencySettingsView.swift
//  TabsUp-DEV
//
//  Created by Thomas Weschke on 09/01/2026.
//

import SwiftUI

struct CurrencySettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SplitViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.darkBackground
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    // CURRENCY Section Header
                    Text("CURRENCY")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 8)
                    
                    // Currency List
                    List {
                        ForEach(Currency.allCurrencies) { currency in
                            CurrencyRow(
                                currency: currency,
                                isSelected: viewModel.selectedCurrency.id == currency.id,
                                onSelect: {
                                    viewModel.setCurrency(currency)
                                }
                            )
                            .listRowBackground(AppColors.cardBackground)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Settings")
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
            }
        }
    }
}

struct CurrencyRow: View {
    let currency: Currency
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(currency.name)
                        .font(.body)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(currency.code)
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Text(currency.symbol)
                        .font(.body)
                        .foregroundColor(AppColors.greenIcon)
                    
                    Toggle("", isOn: .constant(isSelected))
                        .toggleStyle(SwitchToggleStyle(tint: AppColors.greenIcon))
                        .labelsHidden()
                        .disabled(true)
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CurrencySettingsView(viewModel: SplitViewModel())
}
