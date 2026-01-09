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
                                    
                                    // Custom Tip Button
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
                                    currency: viewModel.selectedCurrency,
                                    tipAmount: viewModel.tipAmount,
                                    tipType: viewModel.tipType
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
            return String(format: "%@%.0f", viewModel.selectedCurrency.symbol, amount)
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
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
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
                .padding(.horizontal, 20)
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
        VStack(alignment: .leading, spacing: 16) {
            // First Row: Icon and Label
            HStack(spacing: 12) {
                // Purple People Icon
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.purpleIcon)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "person.2.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    )
                
                // Label
                Text("Number of People")
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                
                Spacer()
            }
            
            // Second Row: Controls - Centered and well-spaced
            HStack {
                Spacer()
                
                // Decrement Button
                Button(action: onDecrement) {
                    Image(systemName: "minus")
                        .font(.headline)
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 44, height: 44)
                        .background(AppColors.purpleIcon.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                // Count Display
                VStack(spacing: 2) {
                    Text("\(count)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    Text("people")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(minWidth: 80)
                .padding(.horizontal, 24)
                
                // Increment Button
                Button(action: onIncrement) {
                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 44, height: 44)
                        .background(AppColors.purpleIcon.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Spacer()
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
    let tipAmount: Double
    let tipType: TipType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Per person (even)")
                .font(.caption)
                .foregroundColor(AppColors.secondaryText)
            
            Text(String(format: "%@%.2f", currency.symbol, amount))
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            // Tip information line
            Text(tipInformationText)
                .font(.caption)
                .foregroundColor(AppColors.secondaryText)
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
    
    private var tipInformationText: String {
        if tipAmount == 0 {
            return "Includes no tip"
        }
        
        let tipAmountFormatted = String(format: "%@%.2f", currency.symbol, tipAmount)
        
        switch tipType {
        case .percentage(let percentage):
            return "Includes \(tipAmountFormatted) tip (\(Int(percentage))%)"
        case .fixedAmount:
            return "Includes \(tipAmountFormatted) tip (fixed)"
        }
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
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct CustomTipView: View {
    @ObservedObject var viewModel: SplitViewModel
    @Binding var isPresented: Bool
    
    @State private var tipMode: TipInputMode = .percentage
    @State private var wholeNumberPart: String = "0"
    @State private var decimalPart: String = ""
    @State private var hasDecimalPoint: Bool = false
    @State private var displayString: String = "0"
    
    enum TipInputMode {
        case percentage
        case fixedAmount
    }
    
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
                    
                    Text("Custom Tip")
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
                
                // Mode Toggle
                HStack(spacing: 12) {
                    Button(action: {
                        tipMode = .percentage
                        resetInput()
                    }) {
                        Text("Percentage")
                            .font(.headline)
                            .foregroundColor(tipMode == .percentage ? AppColors.buttonText : AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(tipMode == .percentage ? AppColors.buttonBackground : AppColors.cardBackground)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        tipMode = .fixedAmount
                        resetInput()
                    }) {
                        Text("Fixed Amount")
                            .font(.headline)
                            .foregroundColor(tipMode == .fixedAmount ? AppColors.buttonText : AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(tipMode == .fixedAmount ? AppColors.buttonBackground : AppColors.cardBackground)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                // Amount Display
                VStack(spacing: 8) {
                    Text(tipMode == .percentage ? "Tip Percentage" : "Tip Amount")
                        .font(.headline)
                        .foregroundColor(AppColors.secondaryText)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        if tipMode == .fixedAmount {
                            Text(viewModel.selectedCurrency.symbol)
                                .font(.system(size: 48, weight: .light))
                                .foregroundColor(AppColors.primaryText)
                        }
                        
                        Text(displayString)
                            .font(.system(size: 48, weight: .light))
                            .foregroundColor(AppColors.secondaryText)
                        
                        if tipMode == .percentage {
                            Text("%")
                                .font(.system(size: 48, weight: .light))
                                .foregroundColor(AppColors.primaryText)
                        }
                    }
                }
                .padding(.top, 32)
                
                Spacer()
                
                // Confirm Button
                Button(action: {
                    confirmTip()
                }) {
                    Text("Confirm Tip")
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
                        KeypadButton(title: "2", subtitle: "") { appendDigit("2") }
                        KeypadButton(title: "3", subtitle: "") { appendDigit("3") }
                    }
                    
                    // Row 2
                    HStack(spacing: 12) {
                        KeypadButton(title: "4", subtitle: "") { appendDigit("4") }
                        KeypadButton(title: "5", subtitle: "") { appendDigit("5") }
                        KeypadButton(title: "6", subtitle: "") { appendDigit("6") }
                    }
                    
                    // Row 3
                    HStack(spacing: 12) {
                        KeypadButton(title: "7", subtitle: "") { appendDigit("7") }
                        KeypadButton(title: "8", subtitle: "") { appendDigit("8") }
                        KeypadButton(title: "9", subtitle: "") { appendDigit("9") }
                    }
                    
                    // Row 4
                    HStack(spacing: 12) {
                        if tipMode == .fixedAmount {
                            KeypadButton(title: ".", subtitle: "") { appendDecimalPoint() }
                        } else {
                            KeypadButton(title: "", subtitle: "") { }
                                .disabled(true)
                                .opacity(0)
                        }
                        KeypadButton(title: "0", subtitle: "") { appendDigit("0") }
                        KeypadButton(title: "", subtitle: "", icon: "delete.left") { backspace() }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            loadCurrentTip()
        }
    }
    
    private func loadCurrentTip() {
        switch viewModel.tipType {
        case .percentage(let percentage):
            tipMode = .percentage
            if viewModel.isCustomTip {
                wholeNumberPart = String(format: "%.0f", percentage)
                displayString = String(format: "%.0f", percentage)
            }
        case .fixedAmount(let amount):
            tipMode = .fixedAmount
            let amountStr = String(format: "%.2f", amount)
            let parts = amountStr.split(separator: ".")
            wholeNumberPart = String(parts[0])
            decimalPart = String(parts[1])
            hasDecimalPoint = true
            displayString = amountStr
        }
    }
    
    private func resetInput() {
        wholeNumberPart = "0"
        decimalPart = ""
        hasDecimalPoint = false
        displayString = tipMode == .percentage ? "0" : "0.00"
    }
    
    private func appendDigit(_ digit: String) {
        if tipMode == .percentage {
            if wholeNumberPart == "0" {
                wholeNumberPart = digit
            } else {
                wholeNumberPart += digit
            }
            displayString = wholeNumberPart
        } else {
            if hasDecimalPoint {
                if decimalPart.count < 2 {
                    decimalPart += digit
                }
            } else {
                if wholeNumberPart == "0" {
                    wholeNumberPart = digit
                } else {
                    wholeNumberPart += digit
                }
            }
            updateDisplayString()
        }
    }
    
    private func appendDecimalPoint() {
        guard tipMode == .fixedAmount else { return }
        if !hasDecimalPoint {
            hasDecimalPoint = true
            updateDisplayString()
        }
    }
    
    private func backspace() {
        if tipMode == .percentage {
            if wholeNumberPart.count > 1 {
                wholeNumberPart.removeLast()
            } else {
                wholeNumberPart = "0"
            }
            displayString = wholeNumberPart
        } else {
            if hasDecimalPoint && !decimalPart.isEmpty {
                decimalPart.removeLast()
                if decimalPart.isEmpty {
                    hasDecimalPoint = false
                }
            } else if !wholeNumberPart.isEmpty && wholeNumberPart != "0" {
                wholeNumberPart.removeLast()
                if wholeNumberPart.isEmpty {
                    wholeNumberPart = "0"
                }
            }
            updateDisplayString()
        }
    }
    
    private func updateDisplayString() {
        if tipMode == .fixedAmount {
            if hasDecimalPoint {
                let decimalDisplay = decimalPart.padding(toLength: 2, withPad: "0", startingAt: 0)
                displayString = "\(wholeNumberPart).\(decimalDisplay)"
            } else {
                displayString = wholeNumberPart
            }
        }
    }
    
    private func confirmTip() {
        if tipMode == .percentage {
            if let percentage = Double(wholeNumberPart) {
                viewModel.setCustomTipPercentage(percentage)
            }
        } else {
            let amountStr = hasDecimalPoint ? "\(wholeNumberPart).\(decimalPart.padding(toLength: 2, withPad: "0", startingAt: 0))" : wholeNumberPart
            if let amount = Double(amountStr) {
                viewModel.setCustomTipAmount(amount)
            }
        }
        isPresented = false
    }
}

#Preview {
    SplitDashboardView()
}
