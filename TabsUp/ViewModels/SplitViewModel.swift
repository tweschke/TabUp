//
//  SplitViewModel.swift
//  TabsUp
//
//  Created by Thomas Weschke on 09/01/2026.
//

import Foundation
import SwiftUI
import Combine

enum TipType {
    case percentage(Double)  // Percentage value (0-100)
    case fixedAmount(Double)  // Fixed dollar amount
}

@MainActor
class SplitViewModel: ObservableObject {
    @Published var billTotal: Double = 0.0 {
        didSet {
            if splitType == .weighted && !people.isEmpty {
                calculateWeightedSplit()
            }
        }
    }
    @Published var tipPercentage: Double = 0.0 {
        didSet {
            if splitType == .weighted && !people.isEmpty {
                calculateWeightedSplit()
            }
        }
    }
    @Published var customTipValue: Double = 0.0 {
        didSet {
            if splitType == .weighted && !people.isEmpty {
                calculateWeightedSplit()
            }
        }
    }
    @Published var tipType: TipType = .percentage(0.0) {
        didSet {
            if splitType == .weighted && !people.isEmpty {
                calculateWeightedSplit()
            }
        }
    }
    @Published var numberOfPeople: Int = 2
    @Published var splitType: SplitType = .even {
        didSet {
            if splitType == .weighted && billTotal > 0 {
                resetPeople()
            }
        }
    }
    @Published var selectedCurrency: Currency = Currency.default
    @Published var people: [Person] = []
    
    private let userDefaultsManager = UserDefaultsManager.shared
    
    init() {
        // Load saved currency preference
        selectedCurrency = userDefaultsManager.selectedCurrency
        
        // Initialize people array
        resetPeople()
    }
    
    // MARK: - Computed Properties
    
    /// Calculates the tip amount based on the current tip type.
    /// Returns 0.0 if billTotal is invalid or tip calculation would overflow.
    var tipAmount: Double {
        guard billTotal >= 0, billTotal.isFinite else { return 0.0 }
        
        switch tipType {
        case .percentage(let percentage):
            guard percentage >= 0, percentage <= 100, percentage.isFinite else { return 0.0 }
            let calculatedTip = billTotal * (percentage / 100.0)
            return calculatedTip.isFinite ? calculatedTip : 0.0
        case .fixedAmount(let amount):
            guard amount >= 0, amount.isFinite else { return 0.0 }
            return amount
        }
    }
    
    var isCustomTip: Bool {
        switch tipType {
        case .percentage(let percentage):
            return !([0, 10, 15, 20, 25].contains(percentage))
        case .fixedAmount:
            return true
        }
    }
    
    /// Calculates the total bill amount including tip.
    /// Returns 0.0 if calculation would overflow or result in invalid value.
    var totalWithTip: Double {
        let total = billTotal + tipAmount
        guard total >= 0, total.isFinite else { return 0.0 }
        return total
    }
    
    /// Calculates the per-person amount for an even split.
    /// Returns 0.0 if numberOfPeople is 0 or calculation would overflow.
    var perPersonEven: Double {
        guard numberOfPeople > 0 else { return 0.0 }
        let total = totalWithTip
        guard total > 0 else { return 0.0 }
        let perPerson = total / Double(numberOfPeople)
        return perPerson.isFinite ? perPerson : 0.0
    }
    
    var weightedRange: (min: Double, max: Double) {
        guard !people.isEmpty else { return (0.0, 0.0) }
        let amounts = people.map { $0.amount }
        return (amounts.min() ?? 0.0, amounts.max() ?? 0.0)
    }
    
    // MARK: - Methods
    
    /// Resets the people array with default values based on numberOfPeople.
    /// Ensures at least 2 people are present and recalculates split if billTotal > 0.
    func resetPeople() {
        // Ensure minimum of 2 people
        if numberOfPeople < 2 {
            numberOfPeople = 2
        }
        
        people = (0..<numberOfPeople).map { index in
            let name = index == 0 ? "You" : "Friend \(index)"
            let defaultShare = 1
            return Person(name: name, shares: defaultShare)
        }
        
        if billTotal > 0 && splitType == .weighted {
            calculateWeightedSplit()
        }
    }
    
    /// Updates the number of people, ensuring minimum of 2.
    /// Resets people array if count changes.
    func updateNumberOfPeople(_ count: Int) {
        let oldCount = numberOfPeople
        numberOfPeople = max(2, count)
        
        if numberOfPeople != oldCount {
            resetPeople()
        }
    }
    
    /// Calculates weighted split amounts based on shares.
    /// Handles edge cases: empty people array, zero total, zero shares, overflow.
    /// Normalizes amounts proportionally based on each person's share ratio.
    func calculateWeightedSplit() {
        guard !people.isEmpty, totalWithTip > 0, totalWithTip.isFinite else {
            // Reset all amounts to 0 if conditions aren't met
            for index in people.indices {
                people[index].amount = 0.0
                people[index].percentage = 0.0
            }
            return
        }
        
        let totalShares = people.reduce(0) { $0 + $1.shares }
        guard totalShares > 0 else {
            // Reset all amounts if no shares
            for index in people.indices {
                people[index].amount = 0.0
                people[index].percentage = 0.0
            }
            return
        }
        
        let total = totalWithTip
        
        // Calculate amounts based on shares
        for index in people.indices {
            let shareRatio = Double(people[index].shares) / Double(totalShares)
            let calculatedAmount = total * shareRatio
            
            // Ensure calculated values are valid and finite
            if calculatedAmount.isFinite && calculatedAmount >= 0 {
                people[index].amount = calculatedAmount
                people[index].percentage = shareRatio * 100.0
            } else {
                people[index].amount = 0.0
                people[index].percentage = 0.0
            }
        }
    }
    
    /// Calculates weighted split amounts based on percentages.
    /// Normalizes percentages to sum to 100% if they don't already.
    /// Handles edge cases: empty people array, zero total, zero percentages, overflow.
    func calculateWeightedSplitByPercentage() {
        guard !people.isEmpty, totalWithTip > 0, totalWithTip.isFinite else {
            // Reset all amounts to 0 if conditions aren't met
            for index in people.indices {
                people[index].amount = 0.0
            }
            return
        }
        
        // Normalize percentages to sum to 100%
        let totalPercentage = people.reduce(0.0) { $0 + $1.percentage }
        guard totalPercentage > 0, totalPercentage.isFinite else {
            // Reset all amounts if no valid percentages
            for index in people.indices {
                people[index].amount = 0.0
                people[index].percentage = 0.0
            }
            return
        }
        
        let normalizationFactor = 100.0 / totalPercentage
        let total = totalWithTip
        
        // Calculate amounts based on normalized percentages
        for index in people.indices {
            let normalizedPercentage = people[index].percentage * normalizationFactor
            let calculatedAmount = total * (normalizedPercentage / 100.0)
            
            // Ensure calculated values are valid and finite
            if calculatedAmount.isFinite && calculatedAmount >= 0 && normalizedPercentage.isFinite {
                people[index].amount = calculatedAmount
                people[index].percentage = normalizedPercentage
            } else {
                people[index].amount = 0.0
                people[index].percentage = 0.0
            }
        }
    }
    
    func updatePersonShares(_ personId: UUID, delta: Int) {
        guard let index = people.firstIndex(where: { $0.id == personId }) else { return }
        
        let newShares = max(1, people[index].shares + delta)
        people[index].shares = newShares
        
        calculateWeightedSplit()
    }
    
    func updatePersonPercentage(_ personId: UUID, delta: Double) {
        guard let index = people.firstIndex(where: { $0.id == personId }) else { return }
        
        let newPercentage = max(0.0, people[index].percentage + delta)
        people[index].percentage = newPercentage
        
        calculateWeightedSplitByPercentage()
    }
    
    func setCurrency(_ currency: Currency) {
        selectedCurrency = currency
        userDefaultsManager.selectedCurrency = currency
    }
    
    /// Sets the tip percentage, clamping to valid range (0-100).
    func setTipPercentage(_ percentage: Double) {
        let clampedPercentage = max(0.0, min(100.0, percentage.isFinite ? percentage : 0.0))
        tipPercentage = clampedPercentage
        tipType = .percentage(clampedPercentage)
        customTipValue = 0.0
    }
    
    /// Sets a custom tip percentage, clamping to valid range (0-100).
    func setCustomTipPercentage(_ percentage: Double) {
        let clampedPercentage = max(0.0, min(100.0, percentage.isFinite ? percentage : 0.0))
        customTipValue = clampedPercentage
        tipPercentage = clampedPercentage
        tipType = .percentage(clampedPercentage)
    }
    
    /// Sets a custom fixed tip amount, ensuring non-negative and finite value.
    func setCustomTipAmount(_ amount: Double) {
        let clampedAmount = max(0.0, amount.isFinite ? amount : 0.0)
        customTipValue = clampedAmount
        tipPercentage = 0.0
        tipType = .fixedAmount(clampedAmount)
    }
    
    func startNewSplit() {
        billTotal = 0.0
        tipPercentage = 0.0
        customTipValue = 0.0
        tipType = .percentage(0.0)
        numberOfPeople = 2
        splitType = .even
        resetPeople()
    }
}
