//
//  UserDefaultsManager.swift
//  TabsUp-DEV
//
//  Created by Thomas Weschke on 09/01/2026.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let currencyKey = "selectedCurrencyCode"
    
    private init() {}
    
    var selectedCurrencyCode: String {
        get {
            UserDefaults.standard.string(forKey: currencyKey) ?? "USD"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: currencyKey)
        }
    }
    
    var selectedCurrency: Currency {
        get {
            Currency.allCurrencies.first { $0.code == selectedCurrencyCode } ?? Currency.default
        }
        set {
            selectedCurrencyCode = newValue.code
        }
    }
}
