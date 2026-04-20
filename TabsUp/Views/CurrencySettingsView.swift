//
//  CurrencySettingsView.swift
//  TabsUp
//
//  Created by Thomas Weschke on 09/01/2026.
//

import SwiftUI

struct CurrencySettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SplitViewModel
    @AppStorage(AppAppearance.storageKey) private var appearanceRawValue: String = AppAppearance.system.rawValue

    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryBackground
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: DesignSpacing.stackFlush) {
                    List {
                        Section {
                            ForEach(AppAppearance.allCases) { mode in
                                Button {
                                    appearanceRawValue = mode.rawValue
                                } label: {
                                    HStack {
                                        Text(mode.displayName)
                                            .font(.body)
                                            .foregroundColor(AppColors.primaryText)
                                        Spacer()
                                        if appearanceRawValue == mode.rawValue {
                                            Image(systemName: "checkmark")
                                                .font(.body.weight(.semibold))
                                                .foregroundColor(AppColors.greenIcon)
                                        }
                                    }
                                    .padding(.vertical, DesignSpacing.tight)
                                }
                                .buttonStyle(.plain)
                                .listRowBackground(AppColors.cardBackground)
                                .listRowSeparator(.hidden)
                            }
                        } header: {
                            Text("APPEARANCE")
                                .font(.caption)
                                .foregroundColor(AppColors.secondaryText)
                        }

                        Section {
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
                        } header: {
                            Text("CURRENCY")
                                .font(.caption)
                                .foregroundColor(AppColors.secondaryText)
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
                VStack(alignment: .leading, spacing: DesignSpacing.tight) {
                    Text(currency.name)
                        .font(.body)
                        .foregroundColor(AppColors.primaryText)

                    Text(currency.code)
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }

                Spacer()

                HStack(spacing: DesignSpacing.related) {
                    Text(currency.symbol)
                        .font(.body)
                        .foregroundColor(AppColors.greenIcon)

                    Toggle("", isOn: .constant(isSelected))
                        .toggleStyle(SwitchToggleStyle(tint: AppColors.greenIcon))
                        .labelsHidden()
                        .disabled(true)
                }
            }
            .padding(.vertical, DesignSpacing.listRowCompact)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CurrencySettingsView(viewModel: SplitViewModel())
}
