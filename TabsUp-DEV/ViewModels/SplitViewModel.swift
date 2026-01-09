//
//  SplitViewModel.swift
//  TabsUp-DEV
//
//  Created by Thomas Weschke on 09/01/2026.
//

import Foundation
import SwiftUI
import Combine

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
    
    var tipAmount: Double {
        billTotal * (tipPercentage / 100.0)
    }
    
    var totalWithTip: Double {
        billTotal + tipAmount
    }
    
    var perPersonEven: Double {
        guard numberOfPeople > 0 else { return 0.0 }
        return totalWithTip / Double(numberOfPeople)
    }
    
    var weightedRange: (min: Double, max: Double) {
        guard !people.isEmpty else { return (0.0, 0.0) }
        let amounts = people.map { $0.amount }
        return (amounts.min() ?? 0.0, amounts.max() ?? 0.0)
    }
    
    // MARK: - Methods
    
    func resetPeople() {
        people = (0..<numberOfPeople).map { index in
            let name = index == 0 ? "You" : "Friend \(index)"
            let defaultShare = 1
            return Person(name: name, shares: defaultShare)
        }
        if billTotal > 0 {
            calculateWeightedSplit()
        }
    }
    
    func updateNumberOfPeople(_ count: Int) {
        let oldCount = numberOfPeople
        numberOfPeople = max(2, count)
        
        if numberOfPeople != oldCount {
            resetPeople()
        }
    }
    
    func calculateWeightedSplit() {
        guard !people.isEmpty, totalWithTip > 0 else { return }
        
        let totalShares = people.reduce(0) { $0 + $1.shares }
        guard totalShares > 0 else { return }
        
        // Calculate amounts based on shares
        for index in people.indices {
            let shareRatio = Double(people[index].shares) / Double(totalShares)
            people[index].amount = totalWithTip * shareRatio
            people[index].percentage = shareRatio * 100.0
        }
    }
    
    func calculateWeightedSplitByPercentage() {
        guard !people.isEmpty, totalWithTip > 0 else { return }
        
        // Normalize percentages to sum to 100%
        let totalPercentage = people.reduce(0.0) { $0 + $1.percentage }
        guard totalPercentage > 0 else { return }
        
        let normalizationFactor = 100.0 / totalPercentage
        
        // Calculate amounts based on normalized percentages
        for index in people.indices {
            let normalizedPercentage = people[index].percentage * normalizationFactor
            people[index].amount = totalWithTip * (normalizedPercentage / 100.0)
            people[index].percentage = normalizedPercentage
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
    
    func startNewSplit() {
        billTotal = 0.0
        tipPercentage = 0.0
        numberOfPeople = 2
        splitType = .even
        resetPeople()
    }
}
