//
//  EnterAmountView.swift
//  TabsUp
//
//  Created by Thomas Weschke on 09/01/2026.
//

import SwiftUI

struct EnterAmountView: View {
    @Binding var amount: Double
    @Binding var isPresented: Bool
    let currency: Currency
    
    @State private var wholeNumberPart: String = "0"
    @State private var decimalPart: String = ""
    @State private var hasDecimalPoint: Bool = false
    @State private var displayString: String = "0.00"
    
    var body: some View {
        ZStack {
            AppColors.darkBackground
                .ignoresSafeArea()
            
            VStack(spacing: DesignSpacing.stackFlush) {
                // Header
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(DesignTypography.sheetNavigationBar)
                            .foregroundColor(AppColors.primaryText)
                    }
                    
                    Spacer()
                    
                    Text("Enter Amount")
                        .font(DesignTypography.sheetNavigationBar)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    // Invisible button for centering
                    Button(action: {}) {
                        Image(systemName: "xmark")
                            .font(DesignTypography.sheetNavigationBar)
                            .foregroundColor(.clear)
                    }
                    .disabled(true)
                }
                .padding(DesignSpacing.insetDefault)
                
                Spacer()
                
                // Amount Display
                VStack(spacing: DesignSpacing.compact) {
                    Text("Bill Total")
                        .font(.headline)
                        .foregroundColor(AppColors.secondaryText)
                    
                    HStack(alignment: .firstTextBaseline, spacing: DesignSpacing.tight) {
                        Text(currency.symbol)
                            .font(DesignTypography.keypadDisplay)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text(displayString)
                            .font(DesignTypography.keypadDisplay)
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                Spacer()
                
                // Confirm Button
                Button(action: {
                    confirmAmount()
                }) {
                    Text("Confirm Amount")
                        .font(.headline)
                        .foregroundColor(AppColors.buttonText)
                        .frame(maxWidth: .infinity)
                        .frame(height: DesignRadius.primaryButtonHeight)
                        .background(AppColors.buttonBackground)
                        .clipShape(Capsule(style: .continuous))
                }
                .padding(.horizontal, DesignSpacing.sheetHorizontal)
                .padding(.bottom, DesignSpacing.screenBottom)
                
                // Keypad
                VStack(spacing: DesignSpacing.related) {
                    // Row 1
                    HStack(spacing: DesignSpacing.related) {
                        KeypadButton(title: "1", subtitle: "") { appendDigit("1") }
                        KeypadButton(title: "2", subtitle: "ABC") { appendDigit("2") }
                        KeypadButton(title: "3", subtitle: "DEF") { appendDigit("3") }
                    }
                    
                    // Row 2
                    HStack(spacing: DesignSpacing.related) {
                        KeypadButton(title: "4", subtitle: "GHI") { appendDigit("4") }
                        KeypadButton(title: "5", subtitle: "JKL") { appendDigit("5") }
                        KeypadButton(title: "6", subtitle: "MNO") { appendDigit("6") }
                    }
                    
                    // Row 3
                    HStack(spacing: DesignSpacing.related) {
                        KeypadButton(title: "7", subtitle: "PQRS") { appendDigit("7") }
                        KeypadButton(title: "8", subtitle: "TUV") { appendDigit("8") }
                        KeypadButton(title: "9", subtitle: "WXYZ") { appendDigit("9") }
                    }
                    
                    // Row 4
                    HStack(spacing: DesignSpacing.related) {
                        KeypadButton(title: ".", subtitle: "") { appendDecimalPoint() }
                        KeypadButton(title: "0", subtitle: "") { appendDigit("0") }
                        KeypadButton(title: "", subtitle: "", icon: "delete.left") { deleteLastDigit() }
                    }
                }
                .padding(.horizontal, DesignSpacing.sheetHorizontal)
                .padding(.bottom, DesignSpacing.screenBottom)
            }
        }
        .onAppear {
            initializeFromAmount()
        }
    }
    
    private func appendDigit(_ digit: String) {
        if hasDecimalPoint {
            // Building decimal part (max 2 digits)
            if decimalPart.count < 2 {
                decimalPart += digit
            }
        } else {
            // Building whole number part
            if wholeNumberPart == "0" {
                wholeNumberPart = digit
            } else {
                wholeNumberPart += digit
            }
        }
        updateDisplayAndAmount()
    }
    
    private func appendDecimalPoint() {
        // Only allow decimal point if we don't already have one
        if !hasDecimalPoint {
            hasDecimalPoint = true
            decimalPart = ""
        }
        updateDisplayAndAmount()
    }
    
    private func deleteLastDigit() {
        if !decimalPart.isEmpty {
            // Remove from decimal part
            decimalPart = String(decimalPart.dropLast())
            if decimalPart.isEmpty {
                hasDecimalPoint = false
            }
        } else if hasDecimalPoint {
            // Remove the decimal point
            hasDecimalPoint = false
        } else if wholeNumberPart.count > 1 {
            // Remove from whole number part
            wholeNumberPart = String(wholeNumberPart.dropLast())
        } else {
            // Reset to zero
            wholeNumberPart = "0"
            decimalPart = ""
            hasDecimalPoint = false
        }
        updateDisplayAndAmount()
    }
    
    private func updateDisplayAndAmount() {
        // Build display string
        if hasDecimalPoint {
            // Has decimal point, show whole number + "." + decimal part (padded to 2 digits)
            let paddedDecimal = decimalPart.padding(toLength: 2, withPad: "0", startingAt: 0)
            displayString = wholeNumberPart + "." + paddedDecimal
        } else {
            // No decimal point, show whole number with .00
            displayString = wholeNumberPart + ".00"
        }
        
        // Update the actual amount value with validation
        if let parsedAmount = Double(displayString), parsedAmount.isFinite, parsedAmount >= 0 {
            amount = parsedAmount
        } else {
            amount = 0.0
        }
    }
    
    private func initializeFromAmount() {
        if amount == 0.0 {
            wholeNumberPart = "0"
            decimalPart = ""
            hasDecimalPoint = false
            displayString = "0.00"
        } else {
            let formatted = String(format: "%.2f", amount)
            let parts = formatted.split(separator: ".")
            wholeNumberPart = String(parts[0])
            if parts.count == 2 {
                decimalPart = String(parts[1])
                hasDecimalPoint = true
            } else {
                decimalPart = ""
                hasDecimalPoint = false
            }
            displayString = formatted
        }
    }
    
    private func confirmAmount() {
        // Validate amount before confirming
        if let parsedAmount = Double(displayString), parsedAmount.isFinite, parsedAmount >= 0 {
            amount = parsedAmount
        } else {
            amount = 0.0
        }
        isPresented = false
    }
}

struct KeypadButton: View {
    let title: String
    let subtitle: String
    var icon: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: DesignSpacing.tight) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(DesignTypography.keypadKeyTitle)
                        .foregroundColor(AppColors.primaryText)
                } else {
                    Text(title)
                        .font(DesignTypography.keypadKeyTitle)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.primaryText)
                    
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.caption2)
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: DesignLayout.keypadRowHeight)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignRadius.sheetControl, style: .continuous))
        }
    }
}

#Preview {
    EnterAmountView(
        amount: .constant(0.0),
        isPresented: .constant(true),
        currency: Currency.default
    )
}
