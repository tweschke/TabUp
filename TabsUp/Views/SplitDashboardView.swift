//
//  SplitDashboardView.swift
//  TabsUp
//
//  Created by Thomas Weschke on 09/01/2026.
//

import SwiftUI
import UIKit

struct SplitDashboardView: View {
    @ObservedObject var viewModel: SplitViewModel
    var pagerSelectedPage: Binding<Int>
    @Environment(\.colorScheme) private var colorScheme
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
                DashboardCanvasBackground()
                
                ScrollView {
                    VStack(spacing: DesignSpacing.stackFlush) {
                        // Title, subtitle, menu, and pager share one compact column (avoids 24pt gap between subtitle and dots).
                        VStack(spacing: DesignSpacing.compact) {
                            HStack(alignment: .top, spacing: DesignSpacing.related) {
                                VStack(alignment: .leading, spacing: DesignSpacing.titleGroup) {
                                    Text("Split")
                                        .font(DesignTypography.dashboardScreenTitle)
                                        .foregroundColor(AppColors.primaryText)

                                    Text("Let's divide that bill fairly")
                                        .font(.subheadline)
                                        .foregroundColor(
                                            colorScheme == .light
                                                ? AppColors.primaryText.opacity(DesignOpacity.subtitleOnLight)
                                                : AppColors.secondaryText
                                        )
                                }

                                Spacer(minLength: DesignSpacing.spacerMinCollapsed)

                                Button(action: {
                                    showCurrencySettings = true
                                }) {
                                    Image(systemName: "line.3.horizontal")
                                        .font(DesignTypography.dashboardBarButton)
                                        .foregroundColor(AppColors.primaryText)
                                        .frame(width: DesignLayout.touchTarget, height: DesignLayout.touchTarget)
                                        .dashboardCircularIconSurface()
                                }
                                .buttonStyle(DashboardSubtlePressButtonStyle())
                                .accessibilityLabel("Settings")
                            }

                            PagerIndicatorView(selection: pagerSelectedPage, pageCount: 2)
                        }
                        .padding(.horizontal, DesignSpacing.screenHorizontal)
                        .padding(.top, DesignSpacing.headerTop)

                        // Total Bill Card — `DesignSpacing.pagerToFirstCard` is tighter than `section` (dots → card).
                        TotalBillCard(
                            amount: viewModel.billTotal,
                            currency: viewModel.selectedCurrency,
                            onTap: {
                                showEnterAmount = true
                            },
                            onCurrencyTap: {
                                showCurrencySettings = true
                            }
                        )
                        .padding(.horizontal, DesignSpacing.screenHorizontal)
                        .padding(.top, DesignSpacing.pagerToFirstCard)

                        VStack(spacing: DesignSpacing.section) {
                        // Tip Selection
                        VStack(alignment: .leading, spacing: DesignSpacing.related) {
                            Text("Add Tip")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, DesignSpacing.screenHorizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: DesignSpacing.related) {
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
                                .padding(.horizontal, DesignSpacing.screenHorizontal)
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
                        .padding(.horizontal, DesignSpacing.screenHorizontal)
                        
                        // Split Type Toggle
                        VStack(alignment: .leading, spacing: DesignSpacing.related) {
                            Text("Split Type")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, DesignSpacing.screenHorizontal)
                            
                            HStack(spacing: DesignSpacing.related) {
                                SplitTypeButton(
                                    title: "Even Split",
                                    systemImage: "person.2.fill",
                                    isSelected: viewModel.splitType == .even,
                                    action: {
                                        viewModel.splitType = .even
                                    }
                                )
                                
                                SplitTypeButton(
                                    title: "% Weighted",
                                    systemImage: "chart.pie.fill",
                                    isSelected: viewModel.splitType == .weighted,
                                    action: {
                                        viewModel.splitType = .weighted
                                        viewModel.resetPeople()
                                    }
                                )
                            }
                            .padding(.horizontal, DesignSpacing.screenHorizontal)
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
                                .padding(.horizontal, DesignSpacing.screenHorizontal)
                            } else {
                                WeightedSplitResultCard(
                                    range: viewModel.weightedRange,
                                    currency: viewModel.selectedCurrency,
                                    tipAmount: viewModel.tipAmount,
                                    tipType: viewModel.tipType,
                                    onCustomize: {
                                        showSplitBreakdown = true
                                    }
                                )
                                .padding(.horizontal, DesignSpacing.screenHorizontal)
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
                                .dashboardPrimaryCTA()
                            }
                            .buttonStyle(DashboardSubtlePressButtonStyle())
                            .padding(.horizontal, DesignSpacing.screenHorizontal)
                            .padding(.bottom, DesignSpacing.screenBottom)
                        }
                        }
                        .padding(.top, DesignSpacing.section)
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
            return String(format: "%@%.2f", viewModel.selectedCurrency.symbol, amount)
        }
    }
}

// MARK: - Total Bill card surface (slightly stronger lift than standard dashboard cards)

private struct TotalBillCardSurfaceModifier: ViewModifier {
    var cornerRadius: CGFloat = DesignRadius.card

    func body(content: Content) -> some View {
        content
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(AppColors.borderSubtle, lineWidth: DesignStroke.hairline)
            )
            .designSplitPrimaryCardShadow()
    }
}

struct TotalBillCard: View {
    let amount: Double
    let currency: Currency
    let onTap: () -> Void
    let onCurrencyTap: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: DesignSpacing.totalBillCore) {
            Button(action: onCurrencyTap) {
                currencyPillLabel
            }
            .buttonStyle(DashboardSubtlePressButtonStyle())
            .accessibilityLabel("Change currency, current \(currency.code)")

            Button(action: onTap) {
                HStack(spacing: DesignSpacing.stackFlush) {
                    VStack(alignment: .leading, spacing: DesignSpacing.inlineTight) {
                        Text("Total Bill")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(AppColors.secondaryText)

                        Text(String(format: "%@%.2f", currency.symbol, amount))
                            .font(DesignTypography.totalBillHero)
                            .foregroundColor(AppColors.primaryText)
                    }

                    Spacer(minLength: DesignSpacing.compact)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(DashboardSubtlePressButtonStyle())
            .accessibilityLabel("Edit total bill amount")
        }
        .padding(DesignSpacing.screenHorizontal)
        .modifier(TotalBillCardSurfaceModifier())
    }

    /// Same active treatment as Add Tip (selected) + Split Type: `tipChipSelectedGradient`, teal border, `DesignRadius.tipChip`.
    @ViewBuilder
    private var currencyPillLabel: some View {
        let core = HStack(spacing: DesignSpacing.inlineTight) {
            Text(currency.code)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.primaryText)

            Image(systemName: "chevron.down")
                .font(.caption2.weight(.semibold))
                .foregroundColor(AppColors.primaryText.opacity(DesignOpacity.currencyChevronMuted))
        }
        .frame(width: DesignLayout.currencyPillWidth, height: DesignLayout.currencyPillHeight)
        .background(AppColors.tipChipSelectedGradient(colorScheme: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: DesignRadius.tipChip, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignRadius.tipChip, style: .continuous)
                .strokeBorder(AppColors.splitTypePillBorderTeal, lineWidth: DesignStroke.chipBorder)
        )

        if colorScheme == .light {
            core
                .designCurrencyPillShadow()
        } else {
            core
        }
    }
}

struct TipButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: action) {
            tipLabel
        }
        .buttonStyle(DashboardSubtlePressButtonStyle())
    }

    @ViewBuilder
    private var tipLabel: some View {
        if colorScheme == .light {
            tipLabelBase
                .shadow(
                    color: DesignElevation.shadowBase.opacity(isSelected ? DesignOpacity.tipChipShadowUpperSelected : DesignOpacity.tipChipShadowUpperUnselected),
                    radius: isSelected ? DesignElevation.TipChip.upperRadiusSelected : DesignElevation.TipChip.upperRadiusUnselected,
                    x: 0,
                    y: DesignElevation.TipChip.upperY
                )
                .shadow(color: DesignElevation.shadowBase.opacity(DesignOpacity.tipChipShadowLower), radius: DesignElevation.TipChip.lowerRadius, x: 0, y: DesignElevation.TipChip.lowerY)
        } else {
            tipLabelBase
        }
    }

    private var tipLabelBase: some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(AppColors.primaryText)
            .padding(.horizontal, DesignSpacing.screenHorizontalWide)
            .frame(height: DesignLayout.touchTarget)
            .background(chipBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignRadius.tipChip, style: .continuous))
            .overlay(chipOverlay)
    }

    private var chipBackground: some ShapeStyle {
        if isSelected {
            return AnyShapeStyle(AppColors.tipChipSelectedGradient(colorScheme: colorScheme))
        }
        return AnyShapeStyle(AppColors.tipChipInactiveFill(colorScheme: colorScheme))
    }

    @ViewBuilder
    private var chipOverlay: some View {
        RoundedRectangle(cornerRadius: DesignRadius.tipChip, style: .continuous)
            .strokeBorder(
                isSelected ? AppColors.splitTypePillBorderTeal : Color.clear,
                lineWidth: isSelected ? DesignStroke.chipBorder : DesignStroke.hidden
            )
    }
}

struct NumberOfPeopleCard: View {
    let count: Int
    let onDecrement: () -> Void
    let onIncrement: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSpacing.subsection) {
            // First Row: Icon and Label
            HStack(spacing: DesignSpacing.related) {
                // Purple People Icon
                RoundedRectangle(cornerRadius: DesignRadius.iconTile, style: .continuous)
                    .fill(AppColors.purpleIcon)
                    .frame(width: DesignLayout.peopleIconTile, height: DesignLayout.peopleIconTile)
                    .overlay(
                        Image(systemName: "person.2.fill")
                            .font(DesignTypography.cardInlineIcon)
                            .foregroundColor(AppColors.buttonText)
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
                        .font(.headline.weight(.semibold))
                        .foregroundColor(stepperIconColor)
                        .frame(width: DesignLayout.touchTarget, height: DesignLayout.touchTarget)
                        .background(stepperFill)
                        .clipShape(RoundedRectangle(cornerRadius: DesignRadius.stepper, style: .continuous))
                }
                .buttonStyle(DashboardSubtlePressButtonStyle())
                
                // Count Display
                VStack(spacing: DesignSpacing.stepperCaption) {
                    Text("\(count)")
                        .font(DesignTypography.largeMetric)
                        .foregroundColor(AppColors.primaryText)
                    Text("people")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(minWidth: DesignLayout.stepperCountMinWidth)
                .padding(.horizontal, DesignSpacing.sheetHorizontal)
                
                // Increment Button
                Button(action: onIncrement) {
                    Image(systemName: "plus")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(stepperIconColor)
                        .frame(width: DesignLayout.touchTarget, height: DesignLayout.touchTarget)
                        .background(stepperFill)
                        .clipShape(RoundedRectangle(cornerRadius: DesignRadius.stepper, style: .continuous))
                }
                .buttonStyle(DashboardSubtlePressButtonStyle())
                
                Spacer()
            }
        }
        .padding(DesignSpacing.insetDefault)
        .splitDashboardPrimaryCardSurface()
    }
    
    private var stepperFill: Color {
        colorScheme == .light
            ? AppColors.stepperPurpleTintLight
            : AppColors.purpleIcon.opacity(DesignOpacity.stepperPurpleDark)
    }

    private var stepperIconColor: Color {
        colorScheme == .light ? AppColors.stepperIconTint : AppColors.primaryText
    }
}

struct SplitTypeButton: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    private var isEvenSplit: Bool { title == "Even Split" }

    var body: some View {
        Button(action: action) {
            splitTypeLabel
        }
        .buttonStyle(DashboardSubtlePressButtonStyle())
    }

    @ViewBuilder
    private var splitTypeLabel: some View {
        if colorScheme == .light && !isSelected {
            splitTypeLabelBase
                .shadow(color: DesignElevation.shadowBase.opacity(DesignElevation.SplitTypeInactive.upperOpacity), radius: DesignElevation.SplitTypeInactive.upperRadius, x: 0, y: DesignElevation.SplitTypeInactive.upperY)
                .shadow(color: DesignElevation.shadowBase.opacity(DesignElevation.SplitTypeInactive.lowerOpacity), radius: DesignElevation.SplitTypeInactive.lowerRadius, x: 0, y: DesignElevation.SplitTypeInactive.lowerY)
        } else {
            splitTypeLabelBase
        }
    }

    private var splitTypeLabelBase: some View {
        HStack(spacing: DesignSpacing.compact) {
            splitLeadingIcon
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.primaryText)
        }
        .frame(maxWidth: .infinity)
        .frame(height: DesignLayout.splitTypeRowHeight)
        .padding(.horizontal, DesignLayout.splitTypeHorizontalInset)
        .background(splitBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignRadius.splitTypeSegment, style: .continuous))
        .overlay(splitOverlay)
    }

    @ViewBuilder
    private var splitLeadingIcon: some View {
        if isEvenSplit {
            evenSplitLeadingIcon
        } else {
            weightedLeadingIcon
        }
    }

    @ViewBuilder
    private var evenSplitLeadingIcon: some View {
        if isSelected {
            if UIImage(named: "SplitTypeEvenPeople") != nil {
                Image("SplitTypeEvenPeople")
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
                    .frame(width: DesignLayout.splitTypeIconWidth, height: DesignLayout.splitTypeIconHeight)
                    .accessibilityHidden(true)
            } else {
                EvenSplitPeopleLayeredFallback()
            }
        } else {
            Image(systemName: "person.2.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(AppColors.primaryText)
        }
    }

    @ViewBuilder
    private var weightedLeadingIcon: some View {
        Image(systemName: "chart.pie.fill")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(
                isSelected
                    ? AnyShapeStyle(AppColors.brandTintGradient(colorScheme: colorScheme))
                    : AnyShapeStyle(AppColors.primaryText)
            )
    }

    private var splitBackground: some ShapeStyle {
        if isSelected {
            return AnyShapeStyle(AppColors.splitTypePillSelectedGradient(colorScheme: colorScheme))
        }
        return AnyShapeStyle(AppColors.splitTypeUnselectedFill(colorScheme: colorScheme))
    }

    @ViewBuilder
    private var splitOverlay: some View {
        if isSelected {
            RoundedRectangle(cornerRadius: DesignRadius.splitTypeSegment, style: .continuous)
                .strokeBorder(AppColors.splitTypePillBorderTeal, lineWidth: DesignStroke.splitTypeSelected)
        } else if colorScheme == .dark {
            RoundedRectangle(cornerRadius: DesignRadius.splitTypeSegment, style: .continuous)
                .strokeBorder(AppColors.splitTypeInactiveBorderColor, lineWidth: DesignStroke.hairline)
        }
    }
}

// MARK: - Even Split icon (fallback until `SplitTypeEvenPeople` asset is added)

private struct EvenSplitPeopleLayeredFallback: View {
    var body: some View {
        ZStack {
            Image(systemName: "person.fill")
                .font(DesignTypography.evenSplitIconRear)
                .foregroundColor(AppColors.splitTypeEvenIconRear)
                .offset(x: DesignLayout.evenIconRearOffsetX, y: DesignLayout.evenIconRearOffsetY)
            Image(systemName: "person.fill")
                .font(DesignTypography.evenSplitIconFront)
                .foregroundColor(AppColors.splitTypePillBorderTeal)
                .offset(x: DesignLayout.evenIconFrontOffsetX, y: DesignLayout.evenIconFrontOffsetY)
        }
        .frame(width: DesignLayout.splitTypeIconWidth, height: DesignLayout.splitTypeIconHeight)
        .accessibilityHidden(true)
    }
}

struct EvenSplitResultCard: View {
    let amount: Double
    let currency: Currency
    let tipAmount: Double
    let tipType: TipType

    var body: some View {
        HStack(alignment: .center, spacing: DesignSpacing.resultRow) {
            VStack(alignment: .leading, spacing: DesignSpacing.compact) {
                Text("Per person (even)")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)

                Text(String(format: "%@%.2f", currency.symbol, amount))
                    .font(DesignTypography.largeMetric)
                    .foregroundColor(AppColors.primaryText)

                Text(tipInformationText)
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image("PerPersonBillIcon")
                .resizable()
                .interpolation(.high)
                .scaledToFit()
                .frame(width: DesignLayout.perPersonBillIcon, height: DesignLayout.perPersonBillIcon)
                .accessibilityHidden(true)
        }
        .padding(DesignSpacing.insetDefault)
        .splitDashboardPrimaryCardSurface()
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
    let tipAmount: Double
    let tipType: TipType
    let onCustomize: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSpacing.subsection) {
            VStack(alignment: .leading, spacing: DesignSpacing.compact) {
                Text("Range (weighted)")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
                
                Text(String(format: "%@%.2f - %@%.2f", currency.symbol, range.min, currency.symbol, range.max))
                    .font(DesignTypography.largeMetric)
                    .foregroundColor(AppColors.primaryText)
                
                // Tip information line
                Text(tipInformationText)
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Button(action: onCustomize) {
                HStack {
                    Text("Customize Split")
                        .font(.headline)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                }
                .dashboardPrimaryCTA()
            }
            .buttonStyle(DashboardSubtlePressButtonStyle())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignSpacing.insetDefault)
        .splitDashboardPrimaryCardSurface()
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
            AppColors.primaryBackground
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
                    
                    Text("Custom Tip")
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
                
                // Mode Toggle
                HStack(spacing: DesignSpacing.related) {
                    Button(action: {
                        tipMode = .percentage
                        resetInput()
                    }) {
                        Text("Percentage")
                            .font(.headline)
                            .foregroundColor(tipMode == .percentage ? AppColors.buttonText : AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: DesignLayout.touchTarget)
                            .background(tipMode == .percentage ? AppColors.buttonBackground : AppColors.chipInactiveBackground)
                            .clipShape(RoundedRectangle(cornerRadius: DesignRadius.sheetControl, style: .continuous))
                            .overlay {
                                if tipMode != .percentage {
                                    RoundedRectangle(cornerRadius: DesignRadius.sheetControl, style: .continuous)
                                        .strokeBorder(AppColors.borderSubtle.opacity(DesignOpacity.borderSubtleSheet), lineWidth: DesignStroke.hairline)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        tipMode = .fixedAmount
                        resetInput()
                    }) {
                        Text("Fixed Amount")
                            .font(.headline)
                            .foregroundColor(tipMode == .fixedAmount ? AppColors.buttonText : AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: DesignLayout.touchTarget)
                            .background(tipMode == .fixedAmount ? AppColors.buttonBackground : AppColors.chipInactiveBackground)
                            .clipShape(RoundedRectangle(cornerRadius: DesignRadius.sheetControl, style: .continuous))
                            .overlay {
                                if tipMode != .fixedAmount {
                                    RoundedRectangle(cornerRadius: DesignRadius.sheetControl, style: .continuous)
                                        .strokeBorder(AppColors.borderSubtle.opacity(DesignOpacity.borderSubtleSheet), lineWidth: DesignStroke.hairline)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, DesignSpacing.sheetHorizontal)
                .padding(.top, DesignSpacing.sheetSectionTop)
                
                // Amount Display
                VStack(spacing: DesignSpacing.compact) {
                    Text(tipMode == .percentage ? "Tip Percentage" : "Tip Amount")
                        .font(.headline)
                        .foregroundColor(AppColors.secondaryText)
                    
                    HStack(alignment: .firstTextBaseline, spacing: DesignSpacing.tight) {
                        if tipMode == .fixedAmount {
                            Text(viewModel.selectedCurrency.symbol)
                                .font(DesignTypography.keypadDisplay)
                                .foregroundColor(AppColors.primaryText)
                        }
                        
                        Text(displayString)
                            .font(DesignTypography.keypadDisplay)
                            .foregroundColor(AppColors.secondaryText)
                        
                        if tipMode == .percentage {
                            Text("%")
                                .font(DesignTypography.keypadDisplay)
                                .foregroundColor(AppColors.primaryText)
                        }
                    }
                }
                .padding(.top, DesignSpacing.sheetDisplayTop)
                
                Spacer()
                
                // Confirm Button
                Button(action: {
                    confirmTip()
                }) {
                    Text("Confirm Tip")
                        .font(.headline)
                        .dashboardPrimaryCTA()
                }
                .buttonStyle(DashboardSubtlePressButtonStyle())
                .padding(.horizontal, DesignSpacing.sheetHorizontal)
                .padding(.bottom, DesignSpacing.screenBottom)
                
                // Keypad
                VStack(spacing: DesignSpacing.related) {
                    // Row 1
                    HStack(spacing: DesignSpacing.related) {
                        KeypadButton(title: "1", subtitle: "") { appendDigit("1") }
                        KeypadButton(title: "2", subtitle: "") { appendDigit("2") }
                        KeypadButton(title: "3", subtitle: "") { appendDigit("3") }
                    }
                    
                    // Row 2
                    HStack(spacing: DesignSpacing.related) {
                        KeypadButton(title: "4", subtitle: "") { appendDigit("4") }
                        KeypadButton(title: "5", subtitle: "") { appendDigit("5") }
                        KeypadButton(title: "6", subtitle: "") { appendDigit("6") }
                    }
                    
                    // Row 3
                    HStack(spacing: DesignSpacing.related) {
                        KeypadButton(title: "7", subtitle: "") { appendDigit("7") }
                        KeypadButton(title: "8", subtitle: "") { appendDigit("8") }
                        KeypadButton(title: "9", subtitle: "") { appendDigit("9") }
                    }
                    
                    // Row 4
                    HStack(spacing: DesignSpacing.related) {
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
                .padding(.horizontal, DesignSpacing.sheetHorizontal)
                .padding(.bottom, DesignSpacing.screenBottom)
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
            decimalPart = ""
            hasDecimalPoint = false
            wholeNumberPart = String(format: "%.0f", percentage)
            displayString = String(format: "%.0f", percentage)
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
    SplitDashboardView(viewModel: SplitViewModel(), pagerSelectedPage: .constant(0))
}
