//
//  Currency.swift
//  TabsUp-DEV
//
//  Created by Thomas Weschke on 09/01/2026.
//

import Foundation

struct Currency: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let code: String
    let symbol: String
    
    static let allCurrencies: [Currency] = [
        Currency(id: "USD", name: "US Dollar", code: "USD", symbol: "$"),
        Currency(id: "EUR", name: "Euro", code: "EUR", symbol: "€"),
        Currency(id: "GBP", name: "British Pound", code: "GBP", symbol: "£"),
        Currency(id: "JPY", name: "Japanese Yen", code: "JPY", symbol: "¥"),
        Currency(id: "CAD", name: "Canadian Dollar", code: "CAD", symbol: "C$"),
        Currency(id: "AUD", name: "Australian Dollar", code: "AUD", symbol: "A$"),
        Currency(id: "CHF", name: "Swiss Franc", code: "CHF", symbol: "CHF"),
        Currency(id: "CNY", name: "Chinese Yuan", code: "CNY", symbol: "¥"),
        Currency(id: "INR", name: "Indian Rupee", code: "INR", symbol: "₹"),
        Currency(id: "MXN", name: "Mexican Peso", code: "MXN", symbol: "$"),
        Currency(id: "BRL", name: "Brazilian Real", code: "BRL", symbol: "R$"),
        Currency(id: "ZAR", name: "South African Rand", code: "ZAR", symbol: "R")
    ]
    
    static let `default` = allCurrencies.first { $0.code == "USD" }!
}
