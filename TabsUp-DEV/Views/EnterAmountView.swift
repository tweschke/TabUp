//
//  EnterAmountView.swift
//  TabsUp-DEV
//
//  Created by Thomas Weschke on 09/01/2026.
//

import SwiftUI

struct EnterAmountView: View {
    @Binding var amount: Double
    @Binding var isPresented: Bool
    let currency: Currency
    
    @State private var amountString: String = "0.00"
    @State private var hasDecimalPoint: Bool = false
    
    var body: some View {
        ZStack {
            AppColors.darkBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(AppColors.primaryText)
                    }
                    
                    Spacer()
                    
                    Text("Enter Amount")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    // Invisible button for centering
                    Button(action: {}) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.clear)
                    }
                    .disabled(true)
                }
                .padding()
                
                Spacer()
                
                // Amount Display
                VStack(spacing: 8) {
                    Text("Bill Total")
                        .font(.headline)
                        .foregroundColor(AppColors.secondaryText)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(currency.symbol)
                            .font(.system(size: 48, weight: .light))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text(amountString)
                            .font(.system(size: 48, weight: .light))
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
                        .frame(height: 56)
                        .background(AppColors.buttonBackground)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                // Keypad
                VStack(spacing: 12) {
                    // Row 1
                    HStack(spacing: 12) {
                        KeypadButton(title: "1", subtitle: "") { appendDigit("1") }
                        KeypadButton(title: "2", subtitle: "ABC") { appendDigit("2") }
                        KeypadButton(title: "3", subtitle: "DEF") { appendDigit("3") }
                    }
                    
                    // Row 2
                    HStack(spacing: 12) {
                        KeypadButton(title: "4", subtitle: "GHI") { appendDigit("4") }
                        KeypadButton(title: "5", subtitle: "JKL") { appendDigit("5") }
                        KeypadButton(title: "6", subtitle: "MNO") { appendDigit("6") }
                    }
                    
                    // Row 3
                    HStack(spacing: 12) {
                        KeypadButton(title: "7", subtitle: "PQRS") { appendDigit("7") }
                        KeypadButton(title: "8", subtitle: "TUV") { appendDigit("8") }
                        KeypadButton(title: "9", subtitle: "WXYZ") { appendDigit("9") }
                    }
                    
                    // Row 4
                    HStack(spacing: 12) {
                        KeypadButton(title: ".", subtitle: "") { appendDecimalPoint() }
                        KeypadButton(title: "0", subtitle: "") { appendDigit("0") }
                        KeypadButton(title: "", subtitle: "", icon: "delete.left") { deleteLastDigit() }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            updateAmountString()
        }
    }
    
    private func appendDigit(_ digit: String) {
        if amountString == "0.00" {
            amountString = digit + ".00"
        } else if hasDecimalPoint {
            let parts = amountString.split(separator: ".")
            if parts.count == 2 && parts[1].count < 2 {
                amountString = String(parts[0]) + "." + String(parts[1]) + digit
            }
        } else {
            amountString += digit
        }
        updateAmount()
    }
    
    private func appendDecimalPoint() {
        if !hasDecimalPoint {
            amountString += "."
            hasDecimalPoint = true
        }
    }
    
    private func deleteLastDigit() {
        if amountString.count > 1 {
            if amountString.last == "." {
                hasDecimalPoint = false
            }
            amountString = String(amountString.dropLast())
            if amountString.isEmpty || amountString == "0" {
                amountString = "0.00"
                hasDecimalPoint = false
            }
        } else {
            amountString = "0.00"
            hasDecimalPoint = false
        }
        updateAmount()
    }
    
    private func updateAmount() {
        amount = Double(amountString) ?? 0.0
    }
    
    private func updateAmountString() {
        amountString = String(format: "%.2f", amount)
        hasDecimalPoint = amountString.contains(".")
    }
    
    private func confirmAmount() {
        amount = Double(amountString) ?? 0.0
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
            VStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(AppColors.primaryText)
                } else {
                    Text(title)
                        .font(.title2)
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
            .frame(height: 60)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
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
